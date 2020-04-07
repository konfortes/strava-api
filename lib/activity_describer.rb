class ActivityDescriber
  def initialize(activity, weather_client)
    @activity = activity
    @weather_client = weather_client
  end

  def describe
    laps_description = LapsDescriber.new(strava_activity).describe
    weather_description = WeatherDescriber.new(strava_activity, WeatherClient).describe

    description = laps_description || ''
    description += "\n\n" if description.present?
    description += weather_description if weather_description

    description
  end
end
