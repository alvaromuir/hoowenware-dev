# activity factory for integration testing

FactoryGirl.define do
  factory :activity do
    activity_type 'resturant'
    name 'An Example Activity'
    link 'http://www.example/com/activity/xxx'
    venue 'An example Venue'
    address '1313 Anywhere Drive Anywhere, USA 00000'
    contact 'John Doe, johndoe@example.com'
    price 9.99
    date (Time.now + 30.days).strftime("%m/%d/%y") 
    start_time ((Time.now + 30.days).change({:hour => 17, :min => 00, :sec => 00 }))
                                    .strftime("%I:%m%p")
    end_time ((Time.now + 30.days).change({:hour => 22, :min => 00, :sec => 00 }))
                                    .strftime("%I:%m%p")
    notes 'An Example Activity with example notes'
    deadline (Time.now + 25.days).strftime("%m/%d/%y") 
    tickets_available 10
    deposit_required true
    cc_required true
    min_age 18
    is_active true
  end
end