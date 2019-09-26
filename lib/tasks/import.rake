namespace :import do
  desc 'Import Activities'

  # TODO: works only for create
  task failed: :environment do
    FailedEvent.unprocessed.each do |event|
      activity_response = client.retrieve_activity(event.object_id)
      next unless activity_response

      strava_activity = Strava::Activity.new(activity_response)
      encoded_polyline = strava_activity.map[:summary_polyline]
      activity = Activity.from_strava_activity(strava_activity)
      ActiveRecord::Base.transaction do
        activity.save!
        # TODO: needed?
        activity.reload

        # TODO: DRY map save
        if encoded_polyline
          decoded_polyline = Polylines::Decoder.decode_polyline(encoded_polyline)

          line_string_text = "LINESTRING(#{decoded_polyline.map { |p| "#{p.first} #{p.second}" }.join(',')})"
          query = "UPDATE activities SET map = ST_GeomFromText('#{line_string_text}', 3785) WHERE id = #{activity.id}"

          ActiveRecord::Base.connection.execute(query)
        end

        event.update!(processed: true)
      end
    end
  end

  task map: :environment do
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

      activities_response.each do |activity_response|
        strava_activity = Strava::Activity.new(activity_response)
        activity = Activity.from_strava_activity(strava_activity)
        activity.save!
        # TODO: does this reload needed, or activity.save! will set the activity.id
        activity.reload

        encoded_polyline = strava_activity.map['summary_polyline']
        next unless encoded_polyline

        decoded_polyline = Polylines::Decoder.decode_polyline(encoded_polyline)
        line_string_text = "LINESTRING(#{decoded_polyline.map { |p| "#{p.first} #{p.second}" }.join(',')})"
        query = "UPDATE activities SET map = ST_GeomFromText('#{line_string_text}', 3785) WHERE id = #{activity.id}"

        ActiveRecord::Base.connection.execute(query)
      end

      # TODO: figure out how to save many. not sure how to do it with map (linestring type)
      # Activity.create!(activities)
    end
  end
end

def client
  user = User.last
  auth_token = user.authorization_token
  Strava::Client.new(access_token: auth_token)
end
