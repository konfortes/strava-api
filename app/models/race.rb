class Race < ActiveRecord::Base
  has_many :race_events

  class Kind
    TRIATHLON = 'Triathlon'.freeze
    CYCLE = 'Cycle'.freeze
    RUN = 'Run'.freeze
    OPEN_WATER = 'Open Water'.freeze
  end
end
