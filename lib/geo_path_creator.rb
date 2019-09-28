class GeoPathCreator
  def initialize(activity_id)
    @activity = Activity.where(external_id: activity_id).last
  end

  def perform
    return if @activity.encoded_path.blank?

    decoded_polyline = Polylines::Decoder.decode_polyline(@activity.encoded_path)
    line_string_text = "LINESTRING(#{decoded_polyline.map { |p| "#{p.first} #{p.second}" }.join(',')})"
    query = "UPDATE activities SET path = ST_GeomFromText('#{line_string_text}', 3785) WHERE id = #{@activity.id}"

    ActiveRecord::Base.connection.execute(query)
  end
end
