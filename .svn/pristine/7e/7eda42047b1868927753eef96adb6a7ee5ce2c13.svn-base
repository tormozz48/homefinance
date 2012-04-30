class Transaction < ActiveRecord::Base
  validates :amount, :date, :created_at, :updated_at, :transaction_type,  :presence => true
  validates :amount, :numericality => {:greater_than_or_equal_to => 0 }
  validates :created_at, :updated_at, :date,  :date =>{:before =>Time.now}
  validates :comment, :length => {:maximum => 255}
  validates :transaction_type, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 7}

  belongs_to :user, :readonly => true
  belongs_to :category, :readonly => true
  belongs_to :account_from,  :readonly => true, :class_name => "Account"
  belongs_to :account_to, :readonly => true, :class_name => "Account"
end
