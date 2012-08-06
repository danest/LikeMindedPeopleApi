class User < ActiveRecord::Base
  attr_accessible :last_name, :name, :fb_id
  
  has_many :profiles, :dependent => :destroy
  has_many :characteristics, :through => :profiles
  
  has_many :interest_points, :dependent => :destroy
  has_many :locations, :through => :interest_points
  
  has_and_belongs_to_many :interests
  
  def current_location
    current_ip = self.interest_points.where(rank: 0).first.location_id if self.interest_points.where(rank: 0).first.present?
    current_location = Location.find(current_ip) if current_ip.present?
    
    current_location
  end
  
  def important_characteristics
    profiles = self.profiles.includes(:characteristic).where('characteristics.key = ?', "Interests").order('likelihood DESC').all
    
    important = Array.new
    profiles.each_with_index do |p, i|
      important[i] = p.characteristic.attributeCategories
      i = i + 1
      break if (i>3)
    end
    
    important
  end
  
end
