class BaseActivitySerializer < ActiveModel::Serializer
  CONVERSION_RATIO = 3.6
  attributes :id, :name, :description ,:distance, :moving_time, :elapsed_time, :type, :start_date_local, :kudos_count,
    :average_speed, :average_pace

  def elapsed_time
    Time.at(object.elapsed_time).utc.strftime("%H:%M:%S")
  end

  def moving_time
    Time.at(object.moving_time).utc.strftime("%H:%M:%S")
  end

  def distance
    (object.distance.to_i / 1000).round(2)
  end

  def average_speed
    "#{(object.average_speed * CONVERSION_RATIO).round(1)} km/h"
  end

  def average_pace
    return if object.type == 'Bike'
    return if object.average_speed.zero?

    if object.type == 'Run'
      secs_per_km = 1000 / object.average_speed
      "#{Time.at(secs_per_km).utc.strftime("%M:%S")}/km"
    elsif object.type == 'Swim'
      # TODO: fix inaccuracy
      secs_per_100m = object.average_speed * 100
      "#{Time.at(secs_per_100m).utc.strftime("%M:%S")}/100m"
    end
  end
end
