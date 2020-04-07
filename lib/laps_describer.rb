class LapsDescriber
  def initialize(activity)
    @activity = activity
  end

  def describe
    return unless @activity.type == Strava::Activity::Type::RUN
    return unless classic_pattern?

    # wu_cd_description.insert(1, main_laps_description).join("\n")
    main_laps_description
  end

  private

  def laps
    @laps ||= ((@activity.laps || []).map { |lap| Lap.new(lap) }.reject! { |lap| lap.moving_time < 20 } || [])
  end

  def classic_pattern?
    laps.count >= 6 && interval_laps.count == recovery_laps.count &&
      interval_laps.count >= 3 &&
      interval_laps.map(&:average_speed).min > recovery_laps.map(&:average_speed).max
  end

  def wu_cd_description
    wu_distance, cd_distance = [wu_lap.distance, cd_lap.distance].map { |distance| (distance / 1000).round(2) }
    ["#{wu_distance} wu", "#{cd_distance} cd"]
  end

  def main_laps_description
    "#{interval_laps.count}*(#{laps_unit(interval_laps)}-#{laps_unit(recovery_laps)}) [#{laps_paces(interval_laps).join(',')}]"
  end

  def main_laps
    laps[1..-2]
  end

  def interval_laps
    interval_laps, = main_laps.partition { |lap| lap.lap_index.even? }
    interval_laps
  end

  def recovery_laps
    _, recovery_laps = main_laps.partition { |lap| lap.lap_index.even? }
    recovery_laps
  end

  def laps_paces(laps)
    laps.map do |lap|
      UnitsConverter.meters_per_second_to_pace_per_km(lap.average_speed)
    end
  end

  def laps_unit(laps)
    if distance_based?(laps)
      distance = laps.second.distance
      if distance >= 1000
        "#{UnitsConverter.meters_to_kms(distance)}km"
      else
        "#{distance}m"
      end
    else # time based
      UnitsConverter.seconds_to_humanized_time(laps.second.moving_time)
    end
  end

  def distance_based?(laps)
    uniqe_distances = laps.map(&:distance).uniq
    uniqe_moving_times = laps.map(&:moving_time).uniq

    uniqe_distances.count == 1 || uniqe_distances.count < uniqe_moving_times.count
  end

  def wu_lap
    laps.first
  end

  def cd_lap
    laps.last
  end
end
