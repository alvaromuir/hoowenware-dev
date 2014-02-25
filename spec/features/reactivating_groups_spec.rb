# Testing Rectivating Groups feature

require 'spec_helper'

feature 'Reactivating Groups feature' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:admin) { FactoryGirl.create(:user, is_admin: true) }
  let!(:group) { FactoryGirl.create(:group, is_active: false) }

  before do

  end

  scenario 'reactivating a group is allowed by admin user' do
    sign_in_as!(admin)
    visit group_url(group)
    click_link 'Reactivate this group'

    expect(page).to have_content("This group has been reactivated.")

    within '#active_groups' do
      expect(page).to have_content(group.name)
    end

    within '#inactive_groups' do
      expect(page).to_not have_content(group.name)
    end
  end


  scenario 'reactivating a group is not allowed by non-trip owner' do
    sign_in_as!(user)
    visit "#{group_url(group)}/reactivate"

    expect(page).to have_content("Sorry, you have to be an admin to do that.")

    visit '/groups'

    expect(page).to_not have_content(group.name)
  end
end