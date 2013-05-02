# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction1, class: Transaction do
    id 1
    user_id 1
    account_from_id nil
    account_to_id 1
    category_id nil
    amount 10
    date 1.week.ago.to_date
    transaction_type Transaction::TR_TO_ACCOUNT
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
    date 1.week.ago.to_date
    transaction_type Transaction::TR_FROM_ACCOUNT_TO_ACCOUNT
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
    date 1.week.ago.to_date
    transaction_type Transaction::TR_FROM_ACCOUNT_TO_CASH
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
    date 1.week.ago.to_date
    transaction_type Transaction::TR_FROM_ACCOUNT_TO_CATEGORY
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
    date 1.week.ago.to_date
    transaction_type Transaction::TR_TO_CASH
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
    date 1.week.ago.to_date
    transaction_type Transaction::TR_FROM_CASH_TO_ACCOUNT
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
    date 1.week.ago.to_date
    transaction_type Transaction::TR_FROM_CASH_TO_CASH
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
    date 1.week.ago.to_date
    transaction_type Transaction::TR_FROM_CASH_TO_CATEGORY
    comment 'transaction from cash to category comment'
    enabled true
  end
end
