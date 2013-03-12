# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account1, class: Account do
    id 1
    name 'Privat Bank Corporate Card'
    description 'Privat Bank Corporate Card'
    amount 0
    account_type 0
    user_id 1
    enabled true
  end

  factory :account2, class: Account do
    id 2
    name 'Cash case 1'
    description 'Cash case 1'
    amount 0
    account_type 1
    user_id 1
    enabled true
  end

  factory :account3, class: Account do
    id 3
    name 'Privat Bank Bonus Card'
    description 'Privat Bank Bonus Card'
    amount 0
    account_type 0
    user_id 1
    enabled true
  end

  factory :account4, class: Account do
    id 4
    name 'Cash case 2'
    description 'Cash case 2'
    amount 0
    account_type 1
    user_id 1
    enabled true
  end
end
