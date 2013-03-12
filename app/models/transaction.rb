class Transaction < ActiveRecord::Base
  #paginates_per 30

  validates :amount,  :presence => true
  validates :date,  :presence => true
  validates :transaction_type,  :presence => true
  validates :user_id,  :presence => true

  validates :user_id, :numericality => {:only_integer => true,
                                        :greater_than_or_equal_to => 0 }
  validates :amount, :numericality => {:greater_than_or_equal_to => 0 }

  validates :comment, :length => {:maximum => 255}
  validates :transaction_type, :numericality => {:only_integer => true,
                                                 :greater_than_or_equal_to => 0,
                                                 :less_than_or_equal_to => 7}

  validate :enabled, :inclusion => { :in => [true, false] }

  belongs_to :user, :readonly => true
  belongs_to :category, :readonly => true
  belongs_to :account_from,  :readonly => true, :class_name => 'Account'
  belongs_to :account_to, :readonly => true, :class_name => 'Account'

  #transaction types
  TR_TO_ACCOUNT = 0
  TR_FROM_ACCOUNT_TO_ACCOUNT = 1
  TR_FROM_ACCOUNT_TO_CASH = 2
  TR_FROM_ACCOUNT_TO_CATEGORY = 3
  TR_TO_CASH = 4
  TR_FROM_CASH_TO_ACCOUNT = 5
  TR_FROM_CASH_TO_CASH = 6
  TR_FROM_CASH_TO_CATEGORY = 7

  TR_TYPES = [TR_TO_ACCOUNT,
              TR_FROM_ACCOUNT_TO_ACCOUNT,
              TR_FROM_ACCOUNT_TO_CASH,
              TR_FROM_ACCOUNT_TO_CATEGORY,
              TR_TO_CASH,
              TR_FROM_CASH_TO_ACCOUNT,
              TR_FROM_CASH_TO_CASH,
              TR_FROM_CASH_TO_CATEGORY]

  TR_GROUP_TO = [TR_TO_ACCOUNT,
                 TR_TO_CASH]

  TR_GROUP_TO_CATEGORY = [TR_FROM_ACCOUNT_TO_CATEGORY,
                          TR_FROM_CASH_TO_CATEGORY]

  TR_GROUP_FROM_TO = [TR_FROM_ACCOUNT_TO_ACCOUNT,
                      TR_FROM_ACCOUNT_TO_CASH,
                      TR_FROM_CASH_TO_ACCOUNT,
                      TR_FROM_CASH_TO_CASH]

  def check_for_account_from
    if account_from_id.nil?
      add_empty_account_from_error
      false
    else
      true
    end
  end

  def check_for_account_to
    if account_to_id.nil?
      add_empty_account_to_error
      false
    else
      true
    end
  end

  def check_for_category
    if category_id.nil?
      add_empty_category_error
      false
    else
      true
    end
  end

  def add_negative_account_error
    errors[:account_from] = I18n.t('message.error.account.negative')
  end

  def add_empty_account_from_error
    errors[:account_from] = I18n.t('message.error.account.empty')
  end

  def add_empty_account_to_error
    errors[:account_to] = I18n.t('message.error.account.empty')
  end

  def add_empty_category_error
    errors[:category] = I18n.t('message.error.category.empty')
  end

  def transfer_sum_to_account
    if check_for_account_to
      account_to = Account.find(account_to_id)
      unless account_to.nil?
        account_to.amount += amount
        account_to.save
      end
      true
    else
      false
    end
  end

  def change_sum_to_account
    if check_for_account_to
      old_transaction = Transaction.find(id)
      diff = amount - old_transaction.amount
      account_to = Account.find(account_to_id)
      unless account_to.nil?
        account_to.amount += diff
        account_to.save
      end
      true
    else
      false
    end
  end

  def rollback_sum_from_account
    if check_for_account_to
      account_to = Account.find(account_to_id)
      account_to.amount -= amount
      if account_to.valid?
        account_to.save
      else
        add_negative_account_error
        return false
      end
      true
    else
      false
    end
  end

  def transfer_sum_between_accounts
    if check_for_account_from && check_for_account_to
      account_from = Account.find(account_from_id)
      account_to = Account.find(account_to_id)
      if !account_from.nil? && !account_to.nil?
        account_from.amount -= amount
        if account_from.valid?
          account_from.save
          account_to.amount += amount
          account_to.save
        else
          add_negative_account_error
          return false
        end
      end
      true
    else
      false
    end
  end

  def change_sum_between_accounts
     if check_for_account_from && check_for_account_to
        old_transaction = Transaction.find(id)
        diff = amount - old_transaction.amount

        account_from = Account.find(account_from_id)
        account_to = Account.find(account_to_id)

        if !account_from.nil? && !account_to.nil?
          account_from.amount -= diff
          if account_from.valid?
            account_from.save
            account_to.amount += diff
            account_to.save
          else
            add_negative_account_error
            return false
          end
        end
        true
     else
       false
     end
  end

  def rollback_sum_between_accounts
    if check_for_account_from && check_for_account_to
      account_from = Account.find(account_from_id)
      account_to = Account.find(account_to_id)
      if !account_from.nil? && !account_to.nil?
        account_to.amount -= amount
        if account_to.valid?
          account_to.save
          account_from.amount += amount
          account_from.save
        else
          add_negative_account_error
          return false
        end
        true
      end
    else
      false
    end
  end

  def transfer_sum_from_account_to_category
    if check_for_account_from && check_for_category
      account_from = Account.find(account_from_id)
      category = Category.find(category_id)
      if !account_from.nil? && !category.nil?
        account_from.amount -= amount
        if account_from.valid?
          account_from.save
          category.amount += amount
          category.save
        else
          add_negative_account_error
          return false
        end
        true
      end
    else
      false
    end
  end

  def change_sum_from_account_to_category
     if check_for_account_from && check_for_category
       old_transaction = Transaction.find(id)
       diff = amount - old_transaction.amount

       account_from = Account.find(account_from_id)
       category = Category.find(category_id)
       if !account_from.nil? && !category.nil?
         account_from.amount -= diff
         if account_from.valid?
           account_from.save
           category.amount += diff
           category.save
         else
           add_negative_account_error
           return false
         end
         true
       end
     else
       false
     end
  end

  def rollback_sum_from_category
    if check_for_account_from && check_for_category
      account_from = Account.find(self.account_from_id)
      if !account_from.nil?
        account_from.amount += amount
        account_from.save
      end
      true
    else
      false
    end
  end

  def calculate_transaction_new
    if transaction_type.in?(TR_GROUP_TO)
      transfer_sum_to_account
    elsif transaction_type.in?(TR_GROUP_FROM_TO)
      transfer_sum_between_accounts
    elsif transaction_type.in?(TR_GROUP_TO_CATEGORY)
      transfer_sum_from_account_to_category
    end
  end

  def calculate_transaction_edit
    if transaction_type.in?(TR_GROUP_TO)
      change_sum_to_account
    elsif transaction_type.in?(TR_GROUP_FROM_TO)
      change_sum_between_accounts
    elsif transaction_type.in?(TR_GROUP_TO_CATEGORY)
      change_sum_from_account_to_category
    end
  end

  def calculate_transaction_destroy
    if transaction_type.in?(TR_GROUP_TO)
      rollback_sum_from_account
    elsif transaction_type.in?(TR_GROUP_FROM_TO)
      rollback_sum_between_accounts
    elsif transaction_type.in?(TR_GROUP_TO_CATEGORY)
      rollback_sum_from_category
    end
  end
end
