class Room < ActiveRecord::Base
  belongs_to :lodging
  belongs_to :trip
  belongs_to :user

  def to_s
    return self.name
  end
end
