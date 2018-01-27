class LapSerializer < ActiveModel::Serializer
  attributes :moving_time, :distance, :average_speed

  def moving_time
    UnitsConverter.seconds_to_humanized_time(object.moving_time)
  end

  def distance
    UnitsConverter.meters_to_kms(object.distance)
  end

  def average_speed
    UnitsConverter.meters_per_second_to_kmh(object.average_speed)
  end
end
