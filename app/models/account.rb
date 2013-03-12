class Account < ActiveRecord::Base
  validates :name, :presence => true
  validates :amount, :presence => true
  validates :account_type, :presence => true
  validates :user_id, :presence => true
  validates :enabled, :presence => true

  validates :name, :uniqueness => {:scope => [:user_id, :account_type, :enabled]}

  validates :amount, :numericality => {:only_integer => false,
                                       :greater_than_or_equal_to => 0 }

  validates :user_id, :numericality => {:only_integer => true,
                                        :greater_than_or_equal_to => 0 }

  validates :account_type, :numericality => {:only_integer => true,
                                             :greater_than_or_equal_to => 0,
                                             :less_than_or_equal_to => 1}

  validates :name, :length => {:minimum => 5, :maximum => 30}
  validates :description, :length => {:maximum => 255}
  validate :enabled, :inclusion => { :in => [true, false] }

  attr_accessible :name, :amount, :description, :account_type, :user, :user_id, :enabled
  attr_readonly :id, :created_at, :updated_at

  belongs_to :user, :readonly => true

  #account types
  ACCOUNT_CARD_TYPE = 0
  ACCOUNT_CASH_TYPE = 1

  ACCOUNT_TYPES = [ACCOUNT_CARD_TYPE, ACCOUNT_CASH_TYPE]

  def name_with_amount
    "#{name} #{amount}"
  end
end
