class Membership < ActiveRecord::Base
  belongs_to :meetup
  belongs_to :user
  validates :user_id, uniqueness: true
end
