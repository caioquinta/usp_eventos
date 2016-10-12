class Event < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :tag_list, length: { maximum: 3, message: 'Selecionar no máximo 3 tags' }
  belongs_to :planner, class_name: 'User'

  has_many :participants
  has_many :users, through: :participants

  acts_as_taggable_on :tags

  has_attached_file :avatar, styles: { medium: '720x480>' }, default_url: '/system/events/missing.png'
  validates_attachment_content_type :avatar, content_type: %r{/\Aimage\/.*\z/}

  scope :next_events, -> { where('begin_date >= ? and begin_date <= ?', DateTime.now.beginning_of_day, DateTime.now.beginning_of_day + 1.month).order(begin_date: :asc) }
  scope :current_events, -> { where('end_date >= ? and begin_date < ?', Time.current, DateTime.now.beginning_of_day).order(end_date: :asc) }

  def self.next_and_current
    next_events + current_events
  end

  def self.preferred(preferences)
    next_events.tagged_with(preferences, any: true) + current_events.tagged_with(preferences, any: true)
  end
end
