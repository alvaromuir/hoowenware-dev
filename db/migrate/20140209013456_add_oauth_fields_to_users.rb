class AddOauthFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :avatar, :string
    add_column :users, :oauth_cred, :hstore
  end
end
