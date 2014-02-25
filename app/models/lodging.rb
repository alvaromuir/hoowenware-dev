class Lodging < ActiveRecord::Base
  validates :name,            :presence => true
  validates :checkin_date,    :presence=> true, 
                              date: { on_or_after: Time.now.strftime("%m/%d/%y")}
  validates :checkout_date,    :presence=> true, 
                              date: { on_or_after: Time.now.strftime("%m/%d/%y")}

  belongs_to :user
  belongs_to :trip

  has_many :rooms, :dependent => :destroy

end
