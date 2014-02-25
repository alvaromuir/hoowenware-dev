class Poll < ActiveRecord::Base
  validates :title, :presence => true
  validates :poll_type,  :presence => true

  belongs_to :trip
  belongs_to :user
  has_many :poll_responses

  def to_s
    return self.title
  end
end
