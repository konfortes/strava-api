# frozen_string_literal: true

class ActivityImporter
  def initialize(strava_activity)
    @strava_activity = strava_activity
  end

  def perform
    activity = ::Activity.from_strava_activity(@strava_activity)
    activity.save!
  end
end
