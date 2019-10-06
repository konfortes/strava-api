class WeatherClient
  API_URL = 'http://api.weatherstack.com/current'.freeze
  API_KEY = Rails.application.secrets.weather_api_key

  class << self
    def current(latlng)
      query = latlng.join(',')
      response = Faraday.get "#{API_URL}?access_key=#{API_KEY}&query=#{query}"

      handle_failed_request(response) && return unless response.status == 200

      JSON(response.body).with_indifferent_access[:current]
    end

    def handle_failed_request(response)
      # TODO: fallback to other provider
      Rails.logger.error("failed weather request: #{response}")
    end
  end
end
