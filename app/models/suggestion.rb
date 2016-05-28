class Suggestion < ActiveRecord::Base
  validates :description, presence: true
end
