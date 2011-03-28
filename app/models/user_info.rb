class UserInfo < ActiveRecord::Base
  belongs_to :user
  has_many :preferences, :through => :user
  attr_accessible :first_name, :last_name, :user_id
end
