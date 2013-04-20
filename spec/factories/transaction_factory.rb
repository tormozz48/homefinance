# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction1, class: Transaction do
    id 1
    user_id 1
    account_from_id nil
    account_to_id 1
    category_id nil
    amount 10
    date '2013-03-09'
    transaction_type 0
    comment 'transaction to account comment'
    enabled true
  end

  factory :transaction2, class: Transaction do
    id 2
    user_id 1
    account_from_id 1
    account_to_id 3
    category_id nil
    amount 10
    date '2013-03-09'
    transaction_type 1
    comment 'transaction from account to account comment'
    enabled true
  end

  factory :transaction3, class: Transaction do
    id 3
    user_id 1
    account_from_id 1
    account_to_id 2
    category_id nil
    amount 10
    date '2013-03-09'
    transaction_type 2
    comment 'transaction from account to cash comment'
    enabled true
  end

  factory :transaction4, class: Transaction do
    id 4
    user_id 1
    account_from_id 1
    account_to_id nil
    category_id 1
    amount 10
    date '2013-03-09'
    transaction_type 3
    comment 'transaction from account to category comment'
    enabled true
  end

  factory :transaction5, class: Transaction do
    id 5
    user_id 1
    account_from_id nil
    account_to_id 2
    category_id nil
    amount 10
    date '2013-03-09'
    transaction_type 4
    comment 'transaction to cash comment'
    enabled true
  end

  factory :transaction6, class: Transaction do
    id 6
    user_id 1
    account_from_id 2
    account_to_id 1
    category_id nil
    amount 10
    date '2013-03-09'
    transaction_type 5
    comment 'transaction from cash to account comment'
    enabled true
  end

  factory :transaction7, class: Transaction do
    id 7
    user_id 1
    account_from_id 2
    account_to_id 4
    category_id nil
    amount 10
    date '2013-03-09'
    transaction_type 6
    comment 'transaction from cash to cash comment'
    enabled true
  end

  factory :transaction8, class: Transaction do
    id 8
    user_id 1
    account_from_id 2
    account_to_id nil
    category_id 1
    amount 10
    date '2013-03-09'
    transaction_type 7
    comment 'transaction from cash to category comment'
    enabled true
  end
end
