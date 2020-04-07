class WeatherDescriber
  def initialize(strava_activity, weather_client)
    @strava_activity = strava_activity
    @weather_client = weather_client
  end

  def describe
    return unless outdoor_activity?

    weather = @weather_client.current(@strava_activity.start_latlng)
    verbalized_weather(weather)
  end

  private

  def outdoor_activity?
    @strava_activity.start_latlng.present?
  end

  def verbalized_weather(weather)
    verbalized = %Q(#{weather[:temperature]}#{[127_777].pack('U*')}
#{wind_direction(weather[:wind_dir])}#{weather[:wind_speed]}km/h#{[127_788].pack('U*')}
#{weather[:humidity]}%#{[128_167].pack('U*')})
    if weather[:temperature] != weather[:feelslike]
      verbalized += %Q(Felt like #{weather[:feelslike]}#{[127_777].pack('U*')})
    end

    verbalized
  end

  def wind_direction(direction)
    code =
      case direction
      when 'WNW', 'NW', 'NNW'
        [8600]
      when 'N'
        [11_015]
      when 'NNE', 'NE', 'ENE'
        [8601]
      when 'E'
        [11_013]
      when 'ESE', 'SE', 'SSE'
        [8598]
      when 'S'
        [11_014]
      when 'SSW', 'SW', 'WSW'
        [8599]
      when 'W'
        [10_145]
      end

    code.pack('U*')
  end
end
