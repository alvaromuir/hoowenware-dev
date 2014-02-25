# Testing Removing Email Invites feature

require 'spec_helper'

feature 'Removing Email Invites feature' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:user3) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }
  let!(:invitation) { FactoryGirl.create(:invitation, trip_id: trip.id,
                                          email: user2.email, 
                                          user_id: user.id)}
  let!(:invitation2) { FactoryGirl.create(:invitation, trip_id: trip.id,
                                          email: user3.email, 
                                          user_id: user.id)}

  before do
    login_as(user, :scope => :user)
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'adding emails to invite' do
    visit edit_trip_path(trip)
    within '.trip-invitations' do
      click_link_or_button 'Email'
    end

    expect(page).to have_content(user2.email)
    expect(page).to have_content(user3.email)

    find(:xpath, "//input[@value='#{user3.email}']").set(true)
    click_link_or_button 'Delete selected'

    expect(page).to_not have_content(user3.email)

  end
end