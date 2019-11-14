class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.string      :external_id
      t.string      :athlete_id
      t.string      :activity_type
      t.string      :name
      t.string      :description
      t.string      :start_date
      t.float       :distance
      t.float       :average_speed
      t.integer     :moving_time
      t.integer     :elapsed_time
      t.float       :average_heartrate
      t.integer     :kudos_count
      t.jsonb       :start_latlng
      t.jsonb       :end_latlng
      t.string      :encoded_path
      t.boolean     :commute

      t.timestamps null: false
    end

    add_foreign_key :activities, :users, column: :athlete_id, primary_key: :uid
    # add_foreign_key :activities, :users
    add_index :activities, :external_id, unique: true
  end
end
