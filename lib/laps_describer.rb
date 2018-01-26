class LapsDescriber
  CONVERSION_RATIO = 3.6

  attr_accessor :activity, :laps

  def initialize(activity)
    @activity = activity
    @laps = activity.laps.map { |lap| Lap.new(lap) }
    sanitize!
  end

  def describe
    raise 'unsupported workout' unless classic_pattern?

    #  interval_time, recovery_time = [interval_laps.second.elapsed_time, recovery_laps.second.elapsed_time]
    #                                 .map { |time| Time.at(time).utc.strftime("%M:%S") }
    wu_distance, cd_distance = [wu_lap.distance, cd_lap.distance].map { |distance| (distance / 1000).round(2) }
    "#{wu_distance} wu + #{interval_laps.count}*(#{interval_unit}-#{recovery_unit}) [#{interval_laps_paces.join(',')}] + #{cd_distance} cd"
  end

  private
    def classic_pattern?
      interval_laps.count == recovery_laps.count && interval_laps.count >= 3
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

    def interval_laps_paces
      interval_laps.map do |lap|
        secs_per_km = 1000 / lap.average_speed
        "#{Time.at(secs_per_km).utc.strftime("%M:%S")}"
       end
    end

    # TODO: baaa refactor
    def interval_unit
      uniqe_distances = interval_laps.map(&:distance).uniq
      uniqe_elapsed_times = interval_laps.map(&:elapsed_time).uniq

      if uniqe_distances.count == 1
        "#{(interval_laps.second.distance / 1000).round(1)}km"
      elsif uniqe_elapsed_times.count == 1
        Time.at(interval_laps.second.elapsed_time).utc.strftime("%M:%S")
      elsif uniqe_distances.count < uniqe_elapsed_times.count
        "#{(interval_laps.second.distance / 1000).round(1)}km"
      else
        Time.at(interval_laps.second.elapsed_time).utc.strftime("%M:%S")
      end
    end

    # TODO: baaa refactor
    def recovery_unit
      uniqe_distances = recovery_laps.map(&:distance).uniq
      uniqe_elapsed_times = recovery_laps.map(&:elapsed_time).uniq

      if uniqe_distances.count == 1
        "#{(recovery_laps.second.distance / 1000).round(1)}"
      elsif uniqe_elapsed_times.count == 1
        Time.at(recovery_laps.second.elapsed_time).utc.strftime("%M:%S")
      elsif uniqe_distances.count < uniqe_elapsed_times.count
        "#{(recovery_laps.second.distance / 1000).round(1)}"
      else
        Time.at(recovery_laps.second.elapsed_time).utc.strftime("%M:%S")
      end
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
