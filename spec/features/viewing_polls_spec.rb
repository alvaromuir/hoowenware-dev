# Testing Viewing Generic Polls feature

require "spec_helper"

feature "Generic Poll Viewing" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }
  let!(:rsvp) { FactoryGirl.create(:rsvp, trip: trip, user: user, response: 'yes') }
  let!(:generic_poll) { FactoryGirl.create(:generic_poll, trip_id: trip.id, user: user) }
  
  before do
    login_as(user, :scope => :user)
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'viewing a generic poll' do
    visit trip_path(trip)

    within '.posts' do
      click_link_or_button generic_poll.title
    end
    
    expect(page).to have_content(generic_poll.generic_question)

  end
end
