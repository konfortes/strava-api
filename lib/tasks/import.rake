namespace :import do
  desc 'Import Activities'

  task map: :environment do
    user = User.last
    auth_token = user.authorization_token
    client = Strava::Client.new(access_token: auth_token)

    Activity.find_each do |activity|
      strava_activity = client.retrieve_activity(activity.external_id)
      encoded_polyline = strava_activity.with_indifferent_access.dig(:map, :summary_polyline)
      next if encoded_polyline.blank?

      decoded_polyline = Polylines::Decoder.decode_polyline(encoded_polyline)

      line_string_text = "LINESTRING(#{decoded_polyline.map { |p| "#{p.first} #{p.second}" }.join(',')})"
      query = "UPDATE activities SET map = ST_GeomFromText('#{line_string_text}', 3785) WHERE id = #{activity.id}"

      ActiveRecord::Base.connection.execute(query)
    end
  end

  task activities: :environment do
    user = User.last
    auth_token = user.authorization_token
    client = Strava::Client.new(access_token: auth_token)

    page = 0
    loop do
      page += 1
      # TODO: use Strava::Activity.list_athlete_activities (which will return Strava::Activity)
      activities_response = client.list_athlete_activities(
        after: 10.years.ago.to_i,
        before: 1.second.from_now,
        per_page: 50,
        page: page
      )

      break if activities_response.blank?

      activities = activities_response.map do |activity_response|
        strava_activity = Strava::Activity.new(activity_response)
        Activity.from_strava_activity(strava_activity).to_h
      end

      Activity.create!(activities)
    end
  end
end
