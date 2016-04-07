class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # events a user participates
  has_many :events
  has_many :events, through: :participants

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
