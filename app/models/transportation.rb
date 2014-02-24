class Transportation < ActiveRecord::Base
  validates :transportation_type,   :presence => true
  validates :arrival_city,          :presence => true, length: { minimum:3 }
  validates :departure_city,        :presence => true, length: { minimum:3 }
  
  belongs_to :trip
  belongs_to :user
end
