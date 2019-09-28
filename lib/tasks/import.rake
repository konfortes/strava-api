namespace :import do
  desc 'Import Activities'

  # TODO: works only for create
  task failed: :environment do
    FailedEvent.unprocessed.each do |event|
      ActiveRecord::Base.transaction do
        Strava::ActivityImporter.new(client, event.object_id).perform
        GeoPathCreator.new(event.object_id).perform
        Strava::LapsDescriptionDecorator.new(strava_client, event.object_id).perform
        Strava::WeatherDecorator.new(strava_client, event.object_id).perform

        event.update!(processed: true)
      end
    end
  end

  task activities: :environment do
    page = 0
    loop do
      page += 1

      strava_activities = Strava::Activity.within_date_range(
        client,
        after: 10.years.ago.to_i,
        before: 1.second.from_now,
        per_page: 50,
        page: page
      )

      break if strava_activities.blank?

      strava_activities.each do |strava_activity|
        activity = Activity.from_strava_activity(strava_activity)
        activity.save!

        GeoPathCreator.new(activity.id).perform
      end
    end
  end
end

def client
  user = User.last
  auth_token = user.authorization_token
  Strava::Client.new(access_token: auth_token)
end
