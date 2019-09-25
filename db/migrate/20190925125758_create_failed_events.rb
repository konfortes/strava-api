class CreateFailedEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :failed_events do |t|
      t.string :aspect_type
      t.string :object_type
      t.string :object_id
      t.string :owner_id
      
      t.timestamps null: false
    end
  end
end
