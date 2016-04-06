class Event < ActiveRecord::Base
	belongs_to :planner, class_name: 'User' 

  has_many :participants
  has_many :users, through: :participants
end
