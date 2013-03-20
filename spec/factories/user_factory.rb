FactoryGirl.define do
  factory :user1, class: User do
    id 1
    email 'john_smith@gmail.com'
    encrypted_password '$2a$10$mAZWr0lUGCe0qiiCXq49fe63IKs35gaGE/3dflie0sOc7kES3NTwi'
    reset_password_token nil
    reset_password_sent_at nil
    remember_created_at nil
    sign_in_count 2
    current_sign_in_at '2012-08-08 00:00:00'
    last_sign_in_at '2011-08-16 00:00:00'
    current_sign_in_ip '10.10.10.5'
    last_sign_in_ip '10.10.10.5'
    password_salt nil
    confirmation_token nil
    confirmed_at '2012-08-08 00:00:00'
    confirmation_sent_at '2012-08-08 00:00:00'
    unconfirmed_email nil
    failed_attempts 0
    unlock_token nil
    locked_at  nil
    created_at '2012-08-08 00:00:00'
    updated_at '2012-08-08 00:00:00'
    first_name nil
    last_name nil
    authentication_token nil
    provider nil
    url nil
    nickname nil
    username nil
    end
end