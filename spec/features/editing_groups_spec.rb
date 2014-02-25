# Testing Editing a Groiup

require 'spec_helper'

feature 'Editing Groups' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group) }
  let!(:membership) {FactoryGirl.create(:membership, group_id: group.id, 
                                        email: user.email, is_active: true,
                                        is_admin: true)}

  before do
  end

  scenario 'authorized users can edit a groups details' do
    sign_in_as!(user)
    visit edit_group_path(group)
    fill_in 'Group Name:', with: 'Revised Group Name'
    click_button 'Update'

    expect(page).to have_content('This group has been updated')

    visit group_path(group)
    expect(page).to have_content('Revised Group Name')
  end

  scenario 'unauthorized users can not edit a groups details' do
    sign_in_as!(user2)
    visit edit_group_path(group.id)
    expect(page).to have_content('You cannot edit memberships on this group.')
  end
end
