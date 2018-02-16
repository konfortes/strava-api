class CreateRaces < ActiveRecord::Migration[5.0]
  def change
    create_table :races do |t|
      t.string :name, null: false
      t.string :kind, null: false
      t.string :picture

      t.timestamps
    end
  end
end
