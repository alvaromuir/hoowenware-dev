# Testing Creating Activities feature

require "spec_helper"

feature "Creating Activities feature" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user)}
  let!(:activity) { FactoryGirl.create(:activity, user: user, trip: trip)}

  before do
    login_as(user, :scope => :user)
    visit trip_activity_path(trip, activity)
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'creating an activity' do

    expect(page).to have_content(activity.activity_type)
    expect(page).to have_content(activity.name)
    expect(page).to have_content(activity.link)
    expect(page).to have_content(activity.venue)
    expect(page).to have_content(activity.address)
    expect(page).to have_content(activity.price)
    expect(page).to have_content(activity.date.to_date.strftime("%m/%d/%y"))
    expect(page).to have_content(activity.start_time.to_time.strftime("%I:%m%p"))
    expect(page).to have_content(activity.end_time.to_time.strftime("%I:%m%p"))
    expect(page).to have_content(activity.notes)
    expect(page).to have_content(activity.deadline.to_date.strftime("%m/%d/%y"))
    expect(page).to have_content(activity.tickets_available)

    if activity.deposit_required?
      within '.deposit-requirements' do
        expect(page).to have_content('Yes')
      end
    end

    if activity.cc_required?
      within '.cc-requirements' do
        expect(page).to have_content('Yes')
      end
    end

    expect(page).to have_content(activity.min_age)
  end
end