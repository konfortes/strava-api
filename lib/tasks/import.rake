namespace :import do
  desc 'Import Activities'

  task activities: :environment do
    user = User.last
    auth_token = user.authorization_token
    client = StravaClient.new(access_token: auth_token)

    page = 0
    loop do
      page += 1
      activities_response = client.list_athlete_activities(
        after: 7.years.ago.to_i,
        before: 1.second.from_now,
        per_page: 50,
        page: page
      )

      break if activities_response.blank?

      activities = activities_response.map do |activity_response|
        {
          external_id: activity_response['id'],
          user_id: user.id,
          activity_type: activity_response['type'],
          name: activity_response['name'],
          # description: activity_response['description']
          start_date: activity_response['start_date'],
          distance: activity_response['distance'],
          average_speed: activity_response['average_speed'],
          moving_time: activity_response['moving_time'],
          elapsed_time: activity_response['elapsed_time'],
          average_heartrate: activity_response['average_heartrate'],
          kudos_count: activity_response['kudos_count'],
          start_latlng: activity_response['start_latlng'],
          end_latlng: activity_response['end_latlng'],
          commute: activity_response['commute']
        }
      end

      Activity.create!(activities)
    end
  end
end
