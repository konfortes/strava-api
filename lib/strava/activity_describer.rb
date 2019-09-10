module Strava
  class ActivityDescriber
    def initialize(strava_client, activity_id)
      @strava_client = strava_client
      @activity_id = activity_id
    end

    def perform
      strava_activity = Strava::Activity.find(@strava_client, @activity_id)
      raise ArgumentError, 'activity not found' unless strava_activity

      # TODO: only run supported
      return unless strava_activity.type == Strava::Activity::Type::RUN

      description = ::LapsDescriber.new(strava_activity).describe
      Strava::Activity.update(@strava_client, @activity_id, description: description)
    end
  end
end
