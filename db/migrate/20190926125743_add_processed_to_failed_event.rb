class AddProcessedToFailedEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :failed_events, :processed, :boolean, default: false
  end
end
