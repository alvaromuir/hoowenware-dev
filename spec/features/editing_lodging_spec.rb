# Testing Editing a Lodging feature

require "spec_helper"

feature "Editing a Lodging " do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }
  let!(:rsvp) { FactoryGirl.create(:rsvp, trip: trip, user: user, response: 'yes') }
  let!(:lodging) { FactoryGirl.create(:lodging, trip: trip, user: user) }
  
  before do
    login_as(user, :scope => :user)
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'Editing a lodging itenerary from trips page' do
    visit trip_path(trip)

    within '.going' do
      click_link_or_button 'View lodging itenerary'
    end


    click_link_or_button 'Update this lodging'

    select 'AirBnB', from: 'Lodging Type:'
    fill_in 'Star Rating:', with: 4.2
    fill_in 'Notes:', with: 'Updated lodging details'
    fill_in 'Cover Photo:', with: 'http://www.example/com/airbnb/image2.jpg'

    click_link_or_button 'Update'

    expect(page).to have_content('Your lodging has been updated.')

    within '.going' do
      click_link_or_button 'View lodging itenerary'
    end

    expect(page).to have_content('AirBnB')
    expect(page).to have_content('4.2')
    expect(page).to have_content('Updated lodging details')
    expect(page).to have_content('http://www.example/com/airbnb/image2.jpg')
  end
end
