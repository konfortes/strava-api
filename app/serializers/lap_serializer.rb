class LapSerializer < ActiveModel::Serializer
  CONVERSION_RATIO = 3.6
  attributes :elapsed_time, :distance, :average_speed

  def elapsed_time
    Time.at(object.elapsed_time).utc.strftime("%H:%M:%S") if object.elapsed_time
  end

  def distance
    (object.distance.to_i / 1000).round(2)
  end

  def average_speed
    "#{(object.average_speed * CONVERSION_RATIO).round(1)} km/h" if object.average_speed
  end
end
