class Athlete < OpenStruct
  include ActiveModel::SerializerSupport

  def self.current(client, current_user_id)
    athlete = client.retrieve_current_athlete(current_user_id)
    new(athlete)
  end

  def self.find(client, id)
    athlete = client.retrieve_athlete(id)
    new(athlete)
  end
end
