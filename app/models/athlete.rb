class Athlete < OpenStruct
  include ActiveModel::SerializerSupport

  def self.current(client)
    athlete = client.retrieve_athlete
    new(athlete)
  end

  def self.find(client, id)
    athlete = client.retrieve_athlete(id)
    new(athlete)
  end
end
