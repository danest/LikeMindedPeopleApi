class InterestPoint < ActiveRecord::Base
  attr_accessible :location_id, :rank, :user_id
  
  belongs_to :user
  belongs_to :location
end
