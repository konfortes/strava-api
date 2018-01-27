class Activity < OpenStruct
  include ActiveModel::SerializerSupport

  class Type
    SWIM = 'Swim'
    RIDE = 'Ride'
    RUN = 'Run'
  end
end
