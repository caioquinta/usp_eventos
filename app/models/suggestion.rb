class Suggestion < ActiveRecord::Base
  validates :user_name, presence: true
  validates :description, presence: true
  validates :email, presence: true
end
