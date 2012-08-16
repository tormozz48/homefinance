class Account < ActiveRecord::Base
  validates :name, :amount,  :account_type, :presence => true
  validates :name, :uniqueness => {:scope => [:user_id, :account_type, :enabled]}
  validates :amount, :numericality => {:greater_than_or_equal_to => 0 }
  validates :name, :length => {:minimum => 5, :maximum => 30}
  validates :description, :length => {:maximum => 255}
  validates :account_type, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 1}
  validate :enabled, :inclusion => { :in => [true, false] }

  attr_accessible :name, :amount, :description, :account_type, :user, :user_id, :enabled

  belongs_to :user, :readonly => true

  #account types
  ACCOUNT_CARD_TYPE = 0
  ACCOUNT_CASH_TYPE = 1

  ACCOUNT_TYPES = [ACCOUNT_CARD_TYPE, ACCOUNT_CASH_TYPE]

  def name_with_amount
    "#{name} #{amount}"
  end
end
