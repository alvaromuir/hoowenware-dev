class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :twitter, :linkedin,
                                                :google, :yahoo, :windowslive,
                                                :github, :meetup, :dropbox]

  has_many :memberships, :dependent => :destroy
  has_many :groups, :through => :memberships
  has_many :trips
  has_many :permissions
  has_many :poll_responses
  has_many :invitations
  has_many :authentications
  has_many :web_links
  
  def to_s
    "#{first_name} #{last_name}"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.find_for_facebook_oauth(auth)
    @acct = Authentication.find_for_facebook_oauth(auth)

    where(@acct.slice(:email)).first_or_initialize.tap do |user|
      user.email      = auth.info.email
      user.password   = Devise.friendly_token[0,20]
      user.first_name = auth.info.first_name
      user.last_name  = auth.info.last_name
      user.avatar     = auth.info.image.split('type=')[0]+'type=large'
      user.save!
      @acct.update(user_id: user.id)
    end
  end

  def self.find_for_google_oauth(auth)
    @acct = Authentication.find_for_google_oauth(auth)

    where(@acct.slice(:email)).first_or_initialize.tap do |user|
      user.email      = auth.info.email
      user.password   = Devise.friendly_token[0,20]
      user.first_name = auth.info.first_name
      user.last_name  = auth.info.last_name
      user.avatar     = auth.info.image
      user.save!
      @acct.update(user_id: user.id)
    end
  end

  def self.find_for_dropbox_oauth(auth)
    @acct = Authentication.find_for_dropbox_oauth(auth)

    where(@acct.slice(:email)).first_or_initialize.tap do |user|
      user.email      = auth.info.email
      user.password   = Devise.friendly_token[0,20]
      user.first_name = auth.info.name.split(' ')[0]
      user.last_name  = auth.info.name.split(' ')[1]
      user.avatar     = self.gravatar_url(auth.info.email)
      user.save!
      @acct.update(user_id: user.id)
    end
  end


  def has_facebook_acct?
    @acct = self.authentications.where(:provider => 'facebook')
    if @acct.present?
      return true
    end
    return false
  end

  def facebook_acct
    @acct = self.authentications.where(:provider => 'facebook').first!
  end

  def has_google_acct?
    @acct = self.authentications.where(:provider => 'google')
    if @acct.present?
      return true
    end
    return false
  end

  def google_acct
    @acct = self.authentications.where(:provider => 'google').first!
  end

  def has_dropbox_acct?
    @acct = self.authentications.where(:provider => 'dropbox')
    if @acct.present?
      return true
    end
    return false
  end

  def dropbox_acct
    @acct = self.authentications.where(:provider => 'dropbox').first!
  end

  def has_links?
    @links = self.web_links
    if @links.count > 0
      return true
    end
    return false
  end

  def links
    @links = self.web_links
  end


  def has_activities?
    @activities = Activity.where(:user_id => self.id)
    if @activities.count > 0
      return true
    end
    return false
  end

  def activities
    @activities = Activity.where(:user_id => self.id)
  end

  def has_travel_plans?
    @transportations = Transportation.where(:user_id => self.id)
    if @transportations.count > 0
      return true
    end
    return false
  end

  def travel_plans
    @transportations = Transportation.where(:user_id => self.id)
  end

  def has_lodging_arrangements?
  @lodgings = Lodging.where(:user_id => self.id)
    if @lodgings.count > 0
      return true
    end
    return false
  end

  def lodging_arrangements
    @lodgings = Lodging.where(:user_id => self.id)
  end


  private
    # quick'n durty method to see what the oauth provider returns
    def self.console_log(oauth_response)
      require 'pp'
      5.times { puts '' }
      pp oauth_response
      5.times { puts '' }
    end

    # gravatar imgage url generator
    def self.gravatar_url(email)
      require 'digest/md5'
      hash = Digest::MD5.hexdigest(email.downcase)
      image_src = "http://www.gravatar.com/avatar/#{hash}?s=300"
      return image_src
    end
end
