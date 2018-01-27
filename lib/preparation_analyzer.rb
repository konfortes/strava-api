class PreparationAnalyzer
  attr_accessor :swims, :rides, :runs

  def initialize(activities)
    @swims, other = activities.partition { |activity| activity.type == 'Swim' }
    @rides, @runs = other.partition { |activity| activity.type == 'Ride'}
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
      total_distance: distances.sum / 1000,
      longest_swim: distances.max.to_i / 1000,
      total_time: Time.at(swims.map(&:elapsed_time).sum).utc.strftime("%H:%M:%S")
    }
  end

  def analyze_rides
    distances = rides.map(&:distance)
    {
      total_distance: distances.sum / 1000,
      longest_ride: distances.max.to_i / 1000,
      total_time: Time.at(rides.map(&:elapsed_time).sum).utc.strftime("%H:%M:%S")
    }
  end

  def analyze_runs
    distances = runs.map(&:distance)
    {
      total_distance: distances.sum / 1000,
      longest_run: distances.max.to_i / 1000,
      total_time: Time.at(runs.map(&:elapsed_time).sum).utc.strftime("%H:%M:%S")
    }
  end

  def analyze_totals
    {
      total_distance: [swims, rides, runs].flatten.map(&:distance).sum / 1000,
      total_time: [swims, rides, runs].flatten.map(&:elapsed_time).sum / 3600
    }
  end
end
