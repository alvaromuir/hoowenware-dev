class Group < ActiveRecord::Base
  validates :name, :presence => true

  has_many :memberships
  has_many :users, :through => :memberships
  has_many :trips
  has_many :permissions, as: :thing

  scope :viewable_by, ->(user) do
    joins(:permissions).where(permissions: { action: "view", user_id: user.id })
  end

  def to_s
    return self.name
  end

end
