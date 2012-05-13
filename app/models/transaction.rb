class Transaction < ActiveRecord::Base
  validates :amount, :date, :transaction_type,  :presence => true
  validates :amount, :numericality => {:greater_than_or_equal_to => 0 }
  validates :comment, :length => {:maximum => 255}
  validates :transaction_type, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 7}
  validate :enabled, :inclusion => { :in => [true, false] }

  belongs_to :user, :readonly => true
  belongs_to :category, :readonly => true
  belongs_to :account_from,  :readonly => true, :class_name => "Account"
  belongs_to :account_to, :readonly => true, :class_name => "Account"

  def addNegativeAccountError
    errors[:account_from] = I18n.t(:message_error_account_negative)
  end
end
