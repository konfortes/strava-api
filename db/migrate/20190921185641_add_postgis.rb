class AddPostgis < ActiveRecord::Migration[5.0]
  def change
    enable_extension :postgis
    # ActiveRecord::Base.connection.execute('CREATE EXTENSION IF NOT EXISTS postgis')
  end
end
