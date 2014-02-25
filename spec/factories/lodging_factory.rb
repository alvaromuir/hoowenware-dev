# lodging factory for integration testing
# 
FactoryGirl.define do
  factory :lodging do
    lodging_type 'hotel'
    name 'An Example Lodging Name'
    link 'http://www.example/com/activity/xxx'
    contact 'John Doe, johndoe@example.com'
    checkin_date (Time.now + 30.days).strftime("%m/%d/%y") 
    checkout_date (Time.now + 34.days).strftime("%m/%d/%y") 
    checkin_time ((Time.now + 30.days).change({:hour => 17, :min => 00, :sec => 00 }))
                                        .strftime("%I:%m%p")
    address '1313 Anywhere Drive Anywhere, USA 00000'
    star_rating 4.5
    reviews_link 'http://www.example/com/reviews/xxx'
    notes 'An Example Activity with example notes'
    cover_photo 'http://www.example/com/hotels/image.jpg'
    is_active true
  end
end