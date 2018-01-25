class BaseActivitySerializer < ActiveModel::Serializer
  CONVERSION_RATIO = 3.6

  attributes :id, :name, :distance, :moving_time, :elapsed_time, :type, :start_date_local, :kudos_count,
    :average_speed

    def distance
      (object.distance / 1000).round(2)
    end

    def average_speed
      "#{(object.average_speed * CONVERSION_RATIO).round(1)} km/h"
    end

    def moving_time
      Time.at(object.moving_time).utc.strftime("%H:%M:%S")
    end

    def elapsed_time
      Time.at(object.elapsed_time).utc.strftime("%H:%M:%S")
    end
end
