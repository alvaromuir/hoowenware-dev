# Testing Group Creation

require 'spec_helper'

feature 'Creating A Group feature' do
  before do
    login_as(FactoryGirl.create(:user), :scope => :user)
  end

  scenario 'creating a group' do
    visit '/groups/new'

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

    visit groups_path
    click_link_or_button 'Test Group'
    expect(page).to have_content('Test Group')
    expect(page).to have_content('10001')
    expect(page).to have_content('Example Group Type')
    expect(page).to have_content('https://facebook.com/example_group')
    expect(page).to have_content('https://meetup.com/example_group')
    expect(page).to have_content('gm12345')
  end
end
