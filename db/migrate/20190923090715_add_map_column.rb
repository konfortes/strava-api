class AddMapColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :map, :line_string, srid: 3785
  end
end
