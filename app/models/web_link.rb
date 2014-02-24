class WebLink < ActiveRecord::Base
  validates               :user_id,   :presence => true
  validates               :url,       :presence => true
  validates_uniqueness_of :url,       :scope => :user_id

  belongs_to :user
end