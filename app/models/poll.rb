class Poll < ActiveRecord::Base
  validates :title, :presence => true
  validates :poll_type,  :presence => true

  belongs_to :trip
  has_many :poll_responses
end
