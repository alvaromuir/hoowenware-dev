# Testing Social OAuth authentication

require 'spec_helper'

feature 'Social OAuth Authentication feature' do

  before do
    OmniAuth.config.test_mode = true
  end


  scenario "Sign in with Facebook" do
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: 'fb_123545',
      info: {
        email: 'testaccount@example.com',
        first_name: 'Facebook',
        first_name: 'User',
        image: 'http://www.example.com/img/test12345.jpg?type=square'
      },
      credentials: {
        token: '12456789abcdefghijklmnopqrstuvwzyz!@#$%^&*()-_',
        expires_at: 1397845024
      }
    })
    
    first_name = OmniAuth.config.mock_auth[:facebook][:info][:first_name]

    visit '/users/auth/facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
    expect(page).to have_content "#{first_name}"
  end

  scenario "Sign in with Google" do
    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({
      provider: 'google',
      uid: 'g_123545',
      info: {
        email: 'testaccount@example.com',
        first_name: 'Google',
        first_name: 'User',
        image: 'http://www.example.com/img/test12345.jpg'
      },
      credentials: {
        token: '12456789abcdefghijklmnopqrstuvwzyz!@#$%^&*()-_',
        expires_at: 1397845024
      }
    })

    first_name = OmniAuth.config.mock_auth[:google][:info][:first_name]

    visit '/users/auth/google'

    expect(page).to have_content 'Successfully authenticated from Google account.'
    expect(page).to have_content "#{first_name}"
  end

  scenario "Sign in with Dropbox" do
    OmniAuth.config.mock_auth[:dropbox] = OmniAuth::AuthHash.new({
      provider: 'dropbox',
      uid: 'm_123545',
      info: {
        email: 'testaccount@example.com',
        name: 'Dropbox User'
      },
      credentials: {
        token: '12456789abcdefghijklmnopqrstuvwzyz!@#$%^&*()-_',
        token_secret: 'shhhhhitz@secr3t'
      }
    })
    first_name = OmniAuth.config.mock_auth[:dropbox][:info][:name].split(' ')[0]

    visit '/users/auth/dropbox'

    expect(page).to have_content 'Successfully authenticated from Dropbox account.'
    expect(page).to have_content "#{first_name}"
  end
end
