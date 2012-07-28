class Profile < ActiveRecord::Base
  attr_accessible :characteristic_id, :likelihood, :user_id
  
  belongs_to :users
  belongs_to :characteristics
end
