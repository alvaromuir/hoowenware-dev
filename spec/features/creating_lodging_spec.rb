# Testing Creating a Lodging feature

require "spec_helper"

feature "Creating a Lodging " do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }
  let!(:rsvp) { FactoryGirl.create(:rsvp, trip: trip, user: user, response: 'yes') }
  
  before do
    login_as(user, :scope => :user)
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'creating a lodging itenerary from trips page' do
    visit trip_path(trip)
    within '.going' do
      click_link_or_button 'Add lodging itenerary'
    end

    select 'hotel', from: 'Lodging Type:'
    fill_in 'Name:', with: 'An Example Lodging Name'
    fill_in 'Link:', with: 'http://www.example/com/activity/xxx'
    fill_in 'Contact:', with: 'John Doe, johndoe@example.com'
    fill_in 'Checkin Date:', with: (Time.now + 30.days).strftime("%m/%d/%y")
    fill_in 'Checkin Time:', with: ((Time.now + 30.days).change({:hour => 15, :min => 00, :sec => 00 }))
                                                        .strftime("%I:%m%p")
    fill_in 'Checkout Date:', with: (Time.now + 34.days).strftime("%m/%d/%y")
    fill_in 'Address:', with: '1313 Anywhere Drive Anywhere, USA 00000'
    fill_in 'Star Rating:', with: 4.5
    fill_in 'Reviews Link:', with: 'http://www.example/com/reviews/xxx'
    fill_in 'Notes:', with: 'An Example Activity with example notes'
    fill_in 'Cover Photo:', with: 'http://www.example/com/hotels/image.jpg'

    click_link_or_button 'Create'

    expect(page).to have_content('Your lodging has been created.')
    expect(page).to have_content('View lodging itenerary')
  end

  scenario 'cancel button takes you to trips page' do

    visit trip_path(trip)
      within '.available-lodging' do
        click_link_or_button 'Add lodging'
      end
    click_button 'Cancel'

    expect(page).to have_content('Your changes have been cancelled.')
    current_url.should eq trip_url(trip)
  end
end
