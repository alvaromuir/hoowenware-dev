class Activity < ActiveRecord::Base
  validates :activity_type,   :presence => true
  validates :name,            :presence => true
  validates :date,            :presence=> true, 
                              date: { on_or_after: Time.now.strftime("%m/%d/%y")}


  belongs_to :trip
  belongs_to  :user

  def to_s
    return self.name
  end
end
