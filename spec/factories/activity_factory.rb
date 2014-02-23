# activity factory for integration testing
FactoryGirl.define do
  start = ''
  factory :activity do
    activity_type 'resturant'
    name 'An Example Activity'
    link 'http://www.example/com/activity/xxx'
    venue 'An example Venue'
    address '1313 Anywhere Drive Anywhere, USA 00000'
    contact 'John Doe, johndoe@example.com'
    price 9.99
    date'03/06/14'
    start_time '7:00pm'
    end_time '10:00pm'
    notes'An Example Activity with example notes'
    deadline'03/04/14'
    tickets_available 10
    deposit_required true
    cc_required true
    min_age 18
  end
end