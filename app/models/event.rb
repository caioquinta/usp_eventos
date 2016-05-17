class Event < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true
  validates :location, presence: true

  belongs_to :planner, class_name: 'User'

  has_many :participants
  has_many :users, through: :participants

  scope :next_events, -> { where('begin_date >= ?', DateTime.now.beginning_of_day).order(begin_date: :asc) }
  scope :current_events, -> { where('end_date >= ? and begin_date < ?', Time.current, DateTime.now.beginning_of_day).order(end_date: :asc) }
end
