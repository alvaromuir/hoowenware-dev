# Testing Administering Group Members feature

require 'spec_helper'

feature 'Administering Group Members feature' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:user3) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group) }
  let!(:membership) {FactoryGirl.create(:membership, group_id: group.id, 
                                        email: user.email, is_active: true,
                                        is_admin: true)}
  before do
  end

  after do
  end

  scenario 'authorized users can approve group memberships' do
    sign_in_as!(user)
    visit group_url(group)
    fill_in 'Email:', with: user2.email
    click_link_or_button 'Add Member'

    expect(page).to have_content(user2.email)

    click_link_or_button('approve')

    expect(page).to have_content('Membership has been activated.')
    expect(page).to_not have_content('approve')

    click_link_or_button('deactivate')

    expect(page).to have_content('Membership has been suspended.')
    expect(page).to_not have_content('deactivate')

    click_link_or_button('demote')

    expect(page).to have_content('Membership has been set to normal user.')
    expect(page).to_not have_content('demote')

    click_link_or_button('remove')

    expect(page).to have_content('Member has been removed from group.')
    expect(page).to_not have_content(user2.email)

  end

  scenario 'unauthorized users can not approve group memberships' do
    sign_in_as!(user2)
    visit group_url(group)
    expect(page).to_not have_content("Add Member")
    expect(page).to_not have_content("approve")
  end
end
