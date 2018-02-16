class PreparationAnalyzer
  attr_accessor :swims, :rides, :runs

  def initialize(activities)
    @swims, other = activities.partition { |activity| activity.type == Activity::Type::SWIM }
    @rides, @runs = other.partition { |activity| activity.type == Activity::Type::RIDE }
  end

  def analyze
    {
      swim: analyze_swims,
      ride: analyze_rides,
      run: analyze_runs,
      totals: analyze_totals
    }
  end

  def analyze_swims
    distances = swims.map(&:distance)
    {
      total_distance: UnitsConverter.meters_to_kms(distances.sum),
      longest_swim: UnitsConverter.meters_to_kms(distances.max || 0),
      total_time: UnitsConverter.seconds_to_humanized_time(swims.map(&:elapsed_time).sum)
    }
  end

  def analyze_rides
    distances = rides.map(&:distance)
    {
      total_distance: UnitsConverter.meters_to_kms(distances.sum),
      longest_ride: UnitsConverter.meters_to_kms(distances.max.to_i),
      total_time: UnitsConverter.seconds_to_humanized_time(rides.map(&:elapsed_time).sum)
    }
  end

  def analyze_runs
    distances = runs.map(&:distance)
    {
      total_distance: UnitsConverter.meters_to_kms(distances.sum),
      longest_run: UnitsConverter.meters_to_kms(distances.max.to_i),
      total_time: UnitsConverter.seconds_to_humanized_time(runs.map(&:elapsed_time).sum)
    }
  end

  def analyze_totals
    {
      total_distance: [swims, rides, runs].flatten.map(&:distance).sum / 1000,
      total_time: [swims, rides, runs].flatten.map(&:elapsed_time).sum / 3600
    }
  end
end
