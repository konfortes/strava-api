module Strava
  class WeatherDecorator
    def initialize(strava_client, activity_id)
      @strava_client = strava_client
      @activity_id = activity_id
    end

    def perform
      @strava_activity = Strava::Activity.find(@strava_client, @activity_id)
      raise ArgumentError, 'activity not found' unless @strava_activity

      return unless outdoor_activity?

      # TODO: uncomment
      # description = @strava_activity.description || ''
      # description += "\n\n" if description.present?

      weather = WeatherClient.current(@strava_activity.start_latlng)
      # TODO: uncomment
      # description += verbalized_weather(weather)
      description = verbalized_weather(weather)
      Strava::Activity.update(@strava_client, @activity_id, description: description)
    end

    private

    def outdoor_activity?
      @strava_activity.start_latlng.present?
    end

    def verbalized_weather(weather)
      %Q("#{weather[:temperature]}#{[127_777].pack('U*')}"
"#{wind_direction(weather[:wind_dir])}#{weather[:wind_speed]}km/h#{[127_788].pack('U*')}"
"#{weather[:humidity]}%#{[128_167].pack('U*')}"
"Felt like #{weather[:feelslike]}#{[127_777].pack('U*')}")
    end

    def wind_direction(direction)
      case direction
      when 'NW', 'WNW', 'NNW'
        [8600].pack('U*')
      when 'N'
        [11_015].pack('U*')
      when 'NE', 'ENE', 'NNE'
        [8601].pack('U*')
      when 'E'
        [11_013].pack('U*')
      when 'SE', 'ESE', 'SSE'
        [8598].pack('U*')
      when 'S'
        [11_014].pack('U*')
      when 'SW', 'WSW', 'SSW'
        [8599].pack('U*')
      when 'W'
        [8600].pack('U*')
      end
    end
  end
end
