class Location < ActiveRecord::Base
  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  attr_accessible :latitude, :longitude, :radius
  
  has_many :interest_points, :dependent => :destroy
  has_many :users, :through => :interest_points
end
