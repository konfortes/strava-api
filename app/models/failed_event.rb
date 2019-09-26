class FailedEvent < ActiveRecord::Base
  scope :unprocessed, -> { where(processed: false) }
end