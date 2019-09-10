# frozen_string_literal: true

module Strava
  class ActivityImporter
    def initialize(strava_client, activity_id)
      @strava_client = strava_client
      @activity_id = activity_id
    end

    def perform
      strava_activity = Strava::Activity.find(@strava_client, @activity_id)
      raise ArgumentError, 'activity not found' unless strava_activity

      activity = ::Activity.from_strava_activity(strava_activity)
      activity.save!
    end
  end
end
