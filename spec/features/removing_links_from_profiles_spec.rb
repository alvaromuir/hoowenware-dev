# Testing Removing Links to User Profiles

require "spec_helper"


feature "Removing Social Links to User Profiles" do
  let!(:user) { FactoryGirl.create(:user) }

  before do
    login_as(user, :scope => :user)
    visit edit_user_path(user)
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'Removing a link' do
    within '#link-form' do
      fill_in 'Link:', with: 'http://www.somenetwork.com/someuser'
      click_link_or_button 'Add'
    end

    expect(page).to have_content('http://www.somenetwork.com/someuser')

    click_link_or_button 'Delete'

    expect(page).to have_content('Link has been removed.')
    expect(page).to_not have_content('http://www.somenetwork.com/someuser')
  end
end