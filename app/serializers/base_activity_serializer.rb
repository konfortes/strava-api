class BaseActivitySerializer < ActiveModel::Serializer
  attributes :id, :name, :distance, :moving_time, :elapsed_time, :type, :start_date_local, :kudos_count,
             :average_speed, :average_pace

  def elapsed_time
    UnitsConverter.seconds_to_humanized_time(object.elapsed_time)
  end

  def moving_time
    UnitsConverter.seconds_to_humanized_time(object.moving_time)
  end

  def distance
    UnitsConverter.meters_to_kms(object.distance)
  end

  def average_speed
    UnitsConverter.meters_per_second_to_kmh(object.average_speed)
  end

  def average_pace
    return if object.average_speed.blank? || object.average_speed.zero?

    if object.type == Strava::Activity::Type::SWIM
      UnitsConverter.meters_per_second_to_pace_per_100m(object.average_speed)
    else
      UnitsConverter.meters_per_second_to_pace_per_km(object.average_speed)
    end
  end
end
