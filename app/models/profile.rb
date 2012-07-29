class Profile < ActiveRecord::Base
  attr_accessible :characteristic_id, :likelihood, :user_id
  
  belongs_to :user
  belongs_to :characteristic
end
