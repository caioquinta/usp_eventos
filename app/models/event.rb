class Event < ActiveRecord::Base
  belongs_to  :planner, class_name: 'User'

  has_many :participants
  has_many :users, through: :participants

  scope :next_events, -> (start_date = Time.current) { where('begin_date >= ?', start_date).order(begin_date: :asc) }
end
