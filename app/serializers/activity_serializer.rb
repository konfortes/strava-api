class ActivitySerializer < BaseActivitySerializer
  attributes :laps

  def laps
    laps = object.laps.map { |lap| Lap.new(lap) }
    ActiveModel::ArraySerializer.new(laps, serializer: LapSerializer)
  end
end
