class User < ActiveRecord::Base
  attr_accessible :last_name, :name, :fb_id
  
  has_many :profiles, :dependent => :destroy
  has_many :characteristics, :through => :profiles
  
  has_many :interest_points, :dependent => :destroy
  has_many :locations, :through => :interest_points
  
  def current_location
    current_ip = self.interest_points.where(rank: 0).first.location_id
    current_location = Location.find(current_ip) if current_ip.present?
    
    current_location
  end
  
end
