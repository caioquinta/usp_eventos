class User < ActiveRecord::Base
  validates :name, presence: true

  has_many :participants
  has_many :events, through: :participants

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
