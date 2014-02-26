# Testing Editing a User Profile

require 'spec_helper'

feature 'Editing Profile' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group) }

  before do
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'editing a users profile' do
    login_as(user, :scope => :user)
    visit edit_user_path(user)

    fill_in 'First Name:', with: 'Christopher'
    fill_in 'Last Name:', with: 'Wallace'
    fill_in 'Zip Code', with: '11222'


    within '#edit_user_form' do
      click_button 'Update'
    end

    expect(page).to have_content('Your profile has been updated')

    visit user_path(user)

    expect(page).to have_content('Christopher')
    expect(page).to have_content('Wallace')
    expect(page).to have_content('11222')
  end


  scenario "non-account holders cannot edit profiles" do
    login_as(user2, :scope => :user)
    visit user_path(user)
    expect(page).to_not have_content('Edit Profile')

    visit edit_user_path(user)
    expect(page).to have_content('You cannot make changes to this profile.')
    current_url.should eq root_url
  end

  scenario "cancel button takes you back to the profile page" do
    login_as(user, :scope => :user)
    visit edit_user_path(user)
    click_button 'Cancel'

    expect(page).to have_content('Your changes have been cancelled.')
    current_url.should eq user_url(user)
  end
end