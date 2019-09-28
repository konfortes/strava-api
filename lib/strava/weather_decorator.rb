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

      description = @strava_activity.description
      description += "\n"
      description += verbalized_weather
      Strava::Activity.update(@strava_client, @activity_id, description: description)
    end

    private

    def outdoor_activity?
      @strava_activity.start_latlng.present?
    end

    # TODO: historical data
    def verbalized_weather
      weather = weather_data

      "It was #{weather[:temperature]} degrees withֿֿֿֿ\
      #{weather[:wind_dir]} #{weather[:wind_speed]}km/h wind and\
      #{weather[:humidity]}% humidity. It felt like #{weather[:feelslike]} degrees"
    end

    def weather_data
      api_key = Rails.application.secrets.weather_api_key
      query = @strava_activity.start_latlng.join(',')
      response = Faraday.get "http://api.weatherstack.com/current?access_key=#{api_key}&query=#{query}"

      handle_failed_request(response) && return unless response.status == 200

      JSON(response.body).with_indifferent_access[:current]
    end

    def handle_failed_request(response)
      # TODO: fallback to other provider
      Rails.logger.error("failed weather request for activity #{@activity_id}. error: #{response.body}")
    end
  end
end
