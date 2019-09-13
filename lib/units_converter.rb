class UnitsConverter
  CONVERSION_RATIO = 3.6
  class << self
    def meters_per_second_to_kmh(meters)
      (meters * CONVERSION_RATIO).round(2)
    end

    def meters_per_second_to_pace_per_km(meters)
      secs_per_km = 1000 / meters
      "#{Time.at(secs_per_km).utc.strftime('%M:%S')}/km"
    end

    # TODO: fix inaccuracy
    def meters_per_second_to_pace_per_100m(meters)
      secs_per_100m = meters * 100
      "#{Time.at(secs_per_100m).utc.strftime('%M:%S')}/100m"
    end

    def seconds_to_humanized_time(seconds)
      Time.at(seconds).utc.strftime('%M:%S')
    end

    def meters_to_kms(meters)
      (meters / 1000).round(2)
    end
  end
end
