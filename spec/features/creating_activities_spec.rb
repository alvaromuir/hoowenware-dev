# Testing Creating Activities feature

require "spec_helper"

feature "Creating Activities feature" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }

  before do
    login_as(user, :scope => :user)
    visit trip_path(trip)
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'creating an activity' do
    click_link_or_button 'Submit an activity'
    
    select 'resturant', from: 'Activity Type:'
    fill_in 'Name:', with: 'An Example Activity'
    fill_in 'Link:', with: 'http://www.example/com/activity/xxx'
    fill_in 'Venue:', with: 'An example Venue'
    fill_in 'Address:', with: '1313 Anywhere Drive Anywhere, USA 00000'
    fill_in 'Contact:', with: 'John Doe, johndoe@example.com'
    fill_in 'Price:', with: '9.99'
    fill_in 'Date:', with: trip.start_date.strftime("%m/%d/%y")
    fill_in 'Start Time:', with: ((trip.start_date + 30.days).change({:hour => 22, :min => 00, :sec => 00 }))
                                                              .strftime("%I:%m%p")
    fill_in 'End Time:', with: ((trip.start_date + 30.days).change({:hour => 22, :min => 00, :sec => 00 }))
                                                            .strftime("%I:%m%p")
    fill_in 'Notes:', with: 'An example Activity'
    fill_in 'Deadline:', with: (trip.start_date-5.days).strftime("%m/%d/%y")
    fill_in 'Tickets Available', with: 10
    check 'Deposit Required?'
    check 'Credit Card Required?'
    fill_in 'Mininum Age:', with: 18

    click_link_or_button 'Submit'
    
    expect(page).to have_content('Your activity request has been receieved and is awaiting approval.')
    expect(page).to have_content('An Example Activity')
  end

  scenario 'cancel button takes you to trips page' do
    click_link_or_button 'Submit an activity' 
    click_button 'Cancel'

    expect(page).to have_content('Your request have been cancelled.')
    current_url.should eq trip_url(trip)
  end
end
