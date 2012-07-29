class User < ActiveRecord::Base
  attr_accessible :last_name, :name, :fb_id
  
  has_many :profiles, :dependent => :destroy
  has_many :characteristics, :through => :profiles
  
  has_many :interest_points, :dependent => :destroy
  has_many :locations, :through => :interest_points
end
