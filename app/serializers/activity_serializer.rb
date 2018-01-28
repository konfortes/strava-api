class ActivitySerializer < BaseActivitySerializer
  attributes :laps, :description

  def laps
    laps = object.laps.map { |lap| Lap.new(lap) }
    ActiveModel::ArraySerializer.new(laps, each_serializer: LapSerializer)
  end
end
