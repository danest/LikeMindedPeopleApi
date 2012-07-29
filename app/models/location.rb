class Location < ActiveRecord::Base
  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  attr_accessible :latitude, :longitude, :radius
  
  has_many :interest_points, :dependent => :destroy
  has_many :users, :through => :interest_points
  
  def important_characteristics
    most_important = Hash.new
    self.users.each do |u|
      u.important_characteristics.each do |c|
        (most_important[c].present?) ? (most_important[c] = most_important[c] + 1) : (most_important[c] = 1)
      end
    end
    
    aux = most_important.sort {|a,b| -1*(a[1]<=>b[1]) }
    important = Array.new
    aux.each_with_index do |c, i|
      important[i] = c[0]
      i = i + 1
      break if (i>3)
    end
    
    important
  end
  
end
