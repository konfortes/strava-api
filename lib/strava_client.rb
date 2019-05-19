class StravaClient

  attr_accessor :client

  def initialize(access_token:)
    @client = Strava::Api::V3::Client.new(access_token: access_token)
  end

  def retrieve_activity(id)
    fetch("activity:#{id}", ttl: 900) do
      client.retrieve_activity(id)
    end
  end

  def list_athlete_activities(options={})
    # TODO: normalize options(ranges) to the beginning of day so it will be able to cache
    fetch("list_athlete_activities:#{options.to_s}") do
      range = options.has_key?(:date) ? day_range(options[:date]) : options.slice(:before, :after)

      activities = client.list_athlete_activities(range)

      activities = sanitize_activities!(activities, options[:sanitize_threshold]) if options[:sanitize_threshold]
      activities
    end
  end

  def update_activity(id)
    client.update_activity(activity.id, params)
  end

  def retrieve_current_athlete(current_user_id)
    fetch("athlete:current:#{current_user_id}", ttl: 1800) do
      client.retrieve_current_athlete
    end
  end

  def retrieve_athlete(id)
    fetch("athlete:#{id}", ttl: 900) do
      client.retrieve_another_athlete(id)
    end
  end

  private
  def day_range(date)
    { before: date.to_i + 1.days, after: date.to_i - 1.days }
  end

  def sanitize_activities!(activities, duration_threshold)
    activities.select { |activity| activity['elapsed_time'] > duration_threshold.minutes }
  end

  def fetch(key, options={})
    value = $redis.get(key)
    value = JSON(value) if value

    unless value
      value = yield
      $redis.pipelined do
        $redis.set(key, value.to_json) if value.present?
        $redis.expire(key, options[:ttl] || 600)
      end
    end
    value
  end
end
