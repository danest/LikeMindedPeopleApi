class User < ActiveRecord::Base
  attr_accessible :last_name, :name
  
  has_many :profiles, :dependent => :destroy
  has_many :characteristics, :through => :profiles
end
