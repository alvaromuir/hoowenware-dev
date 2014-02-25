# Testing Group Viewing

require 'spec_helper'

feature 'Viewing Groups feature' do
  let!(:admin) { FactoryGirl.create(:user, is_admin: true) }
  let!(:group1) { FactoryGirl.create(:group) }
  let!(:group2) { FactoryGirl.create(:group, is_active: false) }

  before do
  end

  scenario 'active groups viewable by everyone' do
    visit '/groups'

    expect(page).to have_content(group1.name)
    expect(page).to_not have_content(group2.name)
  end

  scenario 'inactive groups viewable by admin only' do
    sign_in_as!(admin)

    visit '/groups'

    within '#active_groups' do
      expect(page).to have_content(group1.name)
      expect(page).to_not have_content(group2.name)
    end

    within '#inactive_groups' do
      expect(page).to have_content(group2.name)
      expect(page).to_not have_content(group1.name)
    end
  end
end