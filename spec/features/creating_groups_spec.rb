# Testing Group Creation

require 'spec_helper'

feature 'Creating A Group feature' do
  let!(:user) { FactoryGirl.create(:user) }

  before do
    login_as(user, :scope => :user)
    visit new_group_path
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'creating a group' do
    fill_in 'Group Name:', with: 'Test Group'
    fill_in 'Group Description:', with: 'Test Group'
    fill_in 'Group Location:', with: '10001'
    fill_in 'Group Type:', with: 'Example Group Type'
    fill_in 'Group Avatar:', with: 'http://flickholdr.com/400/300'
    fill_in 'Facebook Link:', with: 'https://facebook.com/example_group'
    fill_in 'Meetup Link:', with: 'https://meetup.com/example_group'
    fill_in 'GroupMe ID:', with: 'gm12345'
    click_link_or_button 'Create'

    expect(page).to have_content('This group has been created.')
  end

  scenario 'cancel button takes you to groups listing page' do
    click_button 'Cancel'

    expect(page).to have_content('Your changes have been cancelled.')
    current_url.should eq groups_url
  end
end
