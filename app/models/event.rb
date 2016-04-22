class Event < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true
  validates :location, presence: true

  belongs_to :planner, class_name: 'User'

  has_many :participants
  has_many :users, through: :participants

  scope :next_events, -> { where('begin_date >= ?', Time.current).order(begin_date: :asc) }
end
