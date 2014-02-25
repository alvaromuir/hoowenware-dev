# Testing Viewing Group Membership feature

require 'spec_helper'

feature 'Viewing Group Membership feature' do
  let!(:user1) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:user3) { FactoryGirl.create(:user) }
  let!(:user4) { FactoryGirl.create(:user) }
  let!(:user5) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group) }
  let!(:membership) {FactoryGirl.create(:membership, group_id: group.id, 
                                          email: user1.email, is_active: true,
                                          is_admin: true)}
  let!(:membership2) {FactoryGirl.create(:membership, group_id: group.id, 
                                          email: user4.email, is_active: true,
                                          is_admin: false)}
  let!(:membership3) {FactoryGirl.create(:membership, group_id: group.id, 
                                          email: user5.email, is_active: false,
                                          is_admin: false)}

  before do
  end

  scenario 'authorized users should be able to view and administer all members' do
    sign_in_as!(user1)
    visit group_url(group)

     within page.all('.member')[2] do
      #  original member created with group
      expect(page).to have_content(user1.full_name)
      expect(page).to_not have_content('approve')
      expect(page).to_not have_content('deactivate')
      expect(page).to_not have_content('promote')
      expect(page).to_not have_content('demote')
      expect(page).to_not have_content('remove')
    end

    fill_in 'Email:', with: user2.email
    click_link_or_button 'Add Member'

    expect(page).to have_content(user2.email)

    within page.all('.member')[0] do
      expect(page).to have_content(user2.email)
      click_link_or_button('approve')
      expect(page).to_not have_content('deactivate')
    end
    expect(page).to have_content('Membership has been activated.')

    within page.all('.member')[0] do
      expect(page).to have_content(user2.full_name)
      expect(page).to_not have_content('approve')
    end


    fill_in 'Email:', with: user3.email
    click_link_or_button 'Add Member'

    expect(page).to have_content(user3.email)
    within page.all('.member')[0] do
      expect(page).to have_content(user3.email)
      click_link_or_button('demote')
    end

    expect(page).to have_content('Membership has been set to normal user.')
    
    within page.all('.member')[0] do
      expect(page).to_not have_content('deactivate')
      expect(page).to_not have_content('demote')
    end
  end

  scenario 'unauthorized members can see only active users' do
    sign_in_as!(user2)
    visit group_url(group)
    
    expect(page).to have_content(user1.full_name)
    expect(page).to have_content(user4.full_name)
    expect(page).to_not have_content(user5.full_name)
  end
end