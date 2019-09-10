namespace :import do
  desc 'Import Activities'

  task activities: :environment do
    user = User.last
    auth_token = user.authorization_token
    client = Strava::Client.new(access_token: auth_token)

    page = 0
    loop do
      page += 1
      # TODO: use Strava::Activity.list_athlete_activities (which will return Strava::Activity)
      activities_response = client.list_athlete_activities(
        after: 7.years.ago.to_i,
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
