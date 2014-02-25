# Testing Adding Group Members feature

require 'spec_helper'

feature 'Adding Group Members feature' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group) }
  let!(:membership) {FactoryGirl.create(:membership, group_id: group.id, 
                                        email: user.email, is_active: true,
                                        is_admin: true)}
  before do
  end

  after do
  end

  scenario 'authorized users can add members to group' do
    sign_in_as!(user)
    visit group_url(group)
    fill_in 'Email:', with: user2.email
    click_link_or_button 'Add Member'

    expect(page).to have_content(user2.email)
  end

  scenario 'unauthorized users can not add memebers to group' do
    sign_in_as!(user2)
    visit group_url(group)
    expect(page).to_not have_content("Add Member")
  end

  scenario 'duplicate members can not be added to group' do
    sign_in_as!(user)
    visit group_url(group)
    fill_in 'Email:', with: user2.email
    click_link_or_button 'Add Member'

    expect(page).to have_content(user2.email)

    fill_in 'Email:', with: user2.email
    click_link_or_button 'Add Member'

    expect(page).to have_content('Duplicate members cannot be added to group.')

  end
end
