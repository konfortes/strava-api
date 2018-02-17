class AthleteSerializer < ActiveModel::Serializer
  attributes :id, :username, :firstname, :lastname, :city, :country, :sex, :created_at, :picture

  def picture
    object.profile_medium
  end
end
