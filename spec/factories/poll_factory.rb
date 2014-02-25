# poll factory for integration testing

FactoryGirl.define do
  start = ''
  factory :poll do
    title { generate(:poll_title) }
    notes 'Lorem impsum foo bar baz'
    expires Time.now + (10*24*60*60)

    factory :date_poll do
      poll_type 'date'
      sequence(:start_date) {|n| start = gen_random_date }
      sequence(:end_date) {|n| gen_random_date(start) }
    end

    factory :location_poll do
      poll_type 'location'
      sequence(:location) {|n| "Location ##{n}"}
    end

    factory :generic_poll do
      poll_type 'generic'
      generic_question 'What do you think about generic test questions?'
    end


  end
end