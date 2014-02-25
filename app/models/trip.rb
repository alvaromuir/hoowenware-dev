class Trip < ActiveRecord::Base
  validates :title,       :presence => true, length: { minimum:10 }
  validates :start_date,  :presence => true
  validates :end_date,    :presence => true
  validates :location,    :presence => true

  belongs_to :user
  has_many :permissions,  as: :thing
  has_many :polls,        :dependent => :destroy
  has_many :invitations,  :dependent => :destroy

  has_many :assets
  accepts_nested_attributes_for :assets

  has_many :rsvps,        :dependent => :destroy
  has_many :posts,        :dependent => :destroy
  has_many :activities,   :dependent => :destroy
  has_many :transportations, :dependent => :destroy
  has_many :lodgings, :dependent => :destroy
  
  scope :viewable_by, ->(user) do
    joins(:permissions).where(permissions: { action: "view", user_id: user.id })
  end

  def to_s
    return self.title
  end

  def has_dates_polls?
    @date_polls =  self.polls.where(:poll_type => 'date')
    if @date_polls.present?
      return true
    end
    return false
  end

  def dates_polls
    return self.polls.where(:poll_type => 'date')
  end

  def has_location_polls?
    @location_polls =  self.polls.where(:poll_type => 'location')
    if @location_polls.present?
      return true
    end
    return false
  end

  def user_rsvp(user)
    return self.rsvps.where(:user_id => user.id).first
  end
  
  def location_polls
    return self.polls.where(:poll_type => 'location')
  end

  def travel_arrangements(user)
    return self.transportations.where(:user_id => user.id)
  end

  def lodging_arrangements(user)
    return self.lodgings.where(:user_id => user.id)
  end

end
