class Meetup < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
  belongs_to :creator, class_name: "User"
  validates :name, presence: true, uniqueness: true
  validates :location, presence: true
  validates :description, presence: true
end
