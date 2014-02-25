# Testing Editing a User Profile

require 'spec_helper'

feature 'Editing Profile' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group) }

  before do
    login_as(user, :scope => :user)
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'editing a users profile' do
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

end
