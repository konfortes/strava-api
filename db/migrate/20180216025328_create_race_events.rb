class CreateRaceEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :race_events do |t|
      t.integer :race_id
      t.integer :year
      t.date :occured_at

      t.timestamps
    end
    add_foreign_key :race_events, :races
    add_index :race_events, :race_id
    add_index :race_events, [:race_id, :year]
  end
end
