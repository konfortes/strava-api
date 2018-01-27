class LapsDescriptor
  CONVERSION_RATIO = 3.6

  attr_accessor :laps

  def initialize(activity)
    @laps = activity.laps.map { |lap| Lap.new(lap) }
    sanitize!
  end

  def describe
    raise 'unsupported workout' unless classic_pattern?

    wu_cd_description.insert(1, main_laps_description).join(' + ')
  end

  private
    def classic_pattern?
      interval_laps.count == recovery_laps.count &&
      interval_laps.map(&:average_speed).min > recovery_laps.map(&:average_speed).max &&
      interval_laps.count >= 3
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
      @interval_laps ||= begin
        interval_laps, _ = main_laps.partition { |lap| lap.lap_index.even? }
        interval_laps
      end
    end

    def recovery_laps
      @recovery_laps ||= begin
        _, recovery_laps = main_laps.partition { |lap| lap.lap_index.even? }
        recovery_laps
      end
    end

    def laps_paces(laps)
      laps.map do |lap|
        secs_per_km = 1000 / lap.average_speed
        "#{Time.at(secs_per_km).utc.strftime("%M:%S")}"
       end
    end

    def laps_unit(laps)
      if distance_based?(laps)
        "#{(laps.second.distance / 1000).round(1)}km"
      else # time based
        Time.at(laps.second.elapsed_time).utc.strftime("%M:%S")
      end
    end

    def distance_based?(laps)
      uniqe_distances = laps.map(&:distance).uniq
      uniqe_elapsed_times = laps.map(&:elapsed_time).uniq

      uniqe_distances.count == 1 || uniqe_distances.count < uniqe_elapsed_times.count
    end

    def wu_lap
      laps.first
    end

    def cd_lap
      laps.last
    end

    def sanitize!
      laps.reject! { |lap| lap.elapsed_time < 20 }
    end
end
