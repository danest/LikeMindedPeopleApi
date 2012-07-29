class Location < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :radius
  
  has_many :interest_points, :dependent => :destroy
  has_many :users, :through => :interest_points
end
