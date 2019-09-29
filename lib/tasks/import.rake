namespace :import do
  # TODO: works only for create
  desc 'Reprocess Failed Activities'
  task failed: :environment do
    FailedEvent.unprocessed.each do |event|
      ActiveRecord::Base.transaction do
        Strava::ActivityImporter.new(client, event.object_id).perform
        GeoPathCreator.new(event.object_id).perform
        Strava::LapsDescriptionDecorator.new(strava_client, event.object_id).perform
        # TODO: uncomment when historical weather available
        # Strava::WeatherDecorator.new(strava_client, event.object_id).perform

        event.update!(processed: true)
      end
    end
  end

  desc 'Import Activities'
  task activities: :environment do
    strava_activities = []
    page = 0
    loop do
      page += 1

      response = Strava::Activity.within_date_range(
        client,
        after: 10.years.ago.to_i,
        before: 1.second.from_now,
        per_page: 50,
        page: page
      )

      break if response.blank?

      strava_activities += response
    end

    strava_activities.reverse.each do |strava_activity|
      next if Activity.where(external_id: strava_activity.id).exists?

      activity = Activity.from_strava_activity(strava_activity)
      activity.save!
      GeoPathCreator.new(activity.external_id).perform
    end
  end
end

# TODO: memoize in class member?
def client
  user = User.last
  auth_token = user.authorization_token
  Strava::Client.new(access_token: auth_token)
end
