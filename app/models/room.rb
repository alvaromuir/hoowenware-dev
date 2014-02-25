class Room < ActiveRecord::Base
  belongs_to :lodging
  belongs_to :trip
  belongs_to :user
end
