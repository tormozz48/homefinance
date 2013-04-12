FactoryGirl.define do
  factory :user1, class: User do
     id 1
     email 'john_smith@gmail.com'
     sign_in_count 2
     password '123456'
     password_confirmation '123456'
     current_sign_in_at '2012-08-08 00:00:00'
     last_sign_in_at '2011-08-16 00:00:00'
     current_sign_in_ip '10.10.10.5'
     last_sign_in_ip '10.10.10.5'
     confirmed_at '2012-08-08 00:00:00'
     confirmation_sent_at '2012-08-08 00:00:00'
     failed_attempts 0
     first_name 'Test First Name'
     last_name 'Test Last Name'
  end
end