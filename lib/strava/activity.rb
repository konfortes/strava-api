module Strava
  class Activity < OpenStruct
    include ActiveModel::SerializerSupport

    class Type
      SWIM = 'Swim'.freeze
      RIDE = 'Ride'.freeze
      RUN = 'Run'.freeze
    end

    # scope :within_date_range, ->(from, to) { where(start_date: from..to) }

    def self.find(client, id)
      activity = client.retrieve_activity(id)
      new(activity)
    end

    def self.within_date_range(client, options = {})
      activities = client.list_athlete_activities(options)
      activities.map { |activity| new(activity) }
    end

    def self.update(client, activity_id, params)
      client.update_activity(activity_id, params)
    end
  end
end
