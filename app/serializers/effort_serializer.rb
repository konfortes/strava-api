class EffortSerializer < ActiveModel::Serializer
  CONVERSION_RATIO = 3.6
  attributes :type, :average_speed

  def average_speed
    "#{(object.average_speed * CONVERSION_RATIO).round(1)} km/h" if object.average_speed
  end
end
