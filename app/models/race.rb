class Race < ActiveRecord::Base
  has_many :race_events

  class Kind
    TRIATHLON = 'Triathlon'
    CYCLE = 'Cycle'
    RUN = 'Run'
    OPEN_WATER = 'Open Water'
  end
end
