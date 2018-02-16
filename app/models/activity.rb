class Activity < OpenStruct
  include ActiveModel::SerializerSupport

  class Type
    SWIM = 'Swim'
    RIDE = 'Ride'
    RUN = 'Run'
  end

  def self.find(client, id)
    activity = client.retrieve_an_activity(id)
    new(activity)
  end

  def self.within_date_range(client, options = {})
    activities = client.list_athlete_activities(options)
    activities.map { |activity| new(activity) }
  end

  def self.update(client, id, params)
    client.update_an_activity(activity.id, params)
  end
end
