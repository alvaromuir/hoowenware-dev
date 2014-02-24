class Invitation < ActiveRecord::Base
  validates :email,   :presence => true
  validates_uniqueness_of :email, :scope => :trip_id

  belongs_to :trip
  has_many :users
end
