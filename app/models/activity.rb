class Activity < ActiveRecord::Base
  belongs_to :user, foreign_key: :athlete_id, primary_key: :uid

  def self.from_strava_activity(activity)
    new(
      external_id: activity.id,
      athlete_id: activity.athlete['id'],
      activity_type: activity.type,
      name: activity.name,
      description: activity.description,
      start_date: activity.start_date,
      distance: activity.distance,
      average_speed: activity.average_speed,
      moving_time: activity.moving_time,
      elapsed_time: activity.elapsed_time,
      average_heartrate: activity.average_heartrate,
      kudos_count: activity.kudos_count,
      start_latlng: activity.start_latlng,
      end_latlng: activity.end_latlng,
      commute: activity.commute,
      encoded_path: activity.map['summary_polyline']
    )
  end

  def to_h
    {
      external_id: external_id,
      athlete_id: athlete_id,
      activity_type: activity_type,
      name: name,
      # description: description
      start_date: start_date,
      distance: distance,
      average_speed: average_speed,
      moving_time: moving_time,
      elapsed_time: elapsed_time,
      average_heartrate: average_heartrate,
      kudos_count: kudos_count,
      start_latlng: start_latlng,
      end_latlng: end_latlng,
      commute: commute?
    }
  end
end
