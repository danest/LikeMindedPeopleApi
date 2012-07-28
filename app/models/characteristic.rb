class Characteristic < ActiveRecord::Base
  attr_accessible :attributeCategories, :key
  
  has_many :profiles, :dependent => :destroy
  has_many :users, :through => :profiles
end
