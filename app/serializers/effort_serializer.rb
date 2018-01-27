class EffortSerializer < ActiveModel::Serializer
  attributes :type, :average_speed

  def average_speed
    UnitsConverter.meters_per_second_to_kmh(object.average_speed)
  end
end
