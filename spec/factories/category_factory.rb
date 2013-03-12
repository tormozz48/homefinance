# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category1, class: Category do
    id 1
    name 'Food'
    description 'Food category'
    amount 0
    color '000000'
    user_id 1
    enabled true
  end
end
