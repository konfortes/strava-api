class StravaClient

  attr_accessor :client

  def initialize(access_token:)
    @client = Strava::Api::V3::Client.new(access_token: access_token)
  end

  def retrieve_an_activity(id)
    client.retrieve_an_activity(id)
  end

  def list_athlete_activities(options = {})
    range = options.has_key?(:date) ? day_range(options[:date]) : options.slice(:before, :after)

    activities = client.list_athlete_activities(range)

    activities = sanitize_activities!(activities, options[:sanitize_threshold]) if options[:sanitize_threshold]
    activities
  end

  def update_an_activity(id, params)
    client.update_an_activity(activity.id, params)
  end

  private
    def day_range(date)
      { before: date.to_i + 1.days, after: date.to_i - 1.days }
    end

    def sanitize_activities!(activities, duration_threshold)
      activities.select { |activity| activity['elapsed_time'] > duration_threshold.minutes }
    end


end
