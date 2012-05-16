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

  def checkForAccountFrom
    valid = true
    if(self.account_from_id.nil?)
      self.addEmptyAccountFromError
      valid = false
    end
    return valid
  end

  def checkForAccountTo
    valid = true
    if(self.account_to_id.nil?)
      self.addEmptyAccountToError
      valid = false
    end
    return valid
  end

  def checkForCategory
    valid = true
    if(self.category_id.nil?)
      self.addEmptyCategoryError
      valid = false
    end
    return valid
  end

  def addNegativeAccountError
    errors[:account_from] = I18n.t(:message_error_account_negative)
  end

  def addEmptyAccountFromError
    errors[:account_from] = I18n.t(:message_error_empty_account)
  end

  def addEmptyAccountToError
    errors[:account_to] = I18n.t(:message_error_empty_account)
  end

  def addEmptyCategoryError
    errors[:category] = I18n.t(:message_error_empty_category)
  end

  def transferSumToAccount
    valid = true
    if self.checkForAccountTo == true
      account_to = Account.find(self.account_to_id)
      if !account_to.nil?
        account_to.amount += self.amount
        account_to.save
      end
    else
      valid = false
    end
    return valid
  end

  def changeSumToAccount
    valid = true
    if self.checkForAccountTo == true
      old_transaction = Transaction.find(self.id)
      diff = self.amount - old_transaction.amount
      account_to = Account.find(self.account_to_id)
      if !account_to.nil?
        account_to.amount += diff
        account_to.save
      end
    else
      valid = false
    end
    return valid
  end

  def rollbackSumFromAccount
    valid = true
    account_to = Account.find(self.account_to_id)
    if !account_to.nil?
      account_to.amount -= self.amount
      if account_to.valid?
        account_to.save
      else
        valid = false
        self.addNegativeAccountError
      end
    else
      valid = false
    end
    return valid
  end

  def transferSumBetweenAccounts
    valid = true
    if self.checkForAccountFrom == true && self.checkForAccountTo == true
      account_from = Account.find(self.account_from_id)
      account_to = Account.find(self.account_to_id)
      if !account_from.nil? && !account_to.nil?
        account_from.amount -= self.amount
        if account_from.valid?
          account_from.save

          account_to.amount += self.amount
          account_to.save
        else
          valid = false
          self.addNegativeAccountError
        end
      end
    else
      valid = false
    end
    return valid
  end

  def changeSumBetweenAccounts
     valid = true
     if self.checkForAccountFrom == true && self.checkForAccountTo == true
        old_transaction = Transaction.find(self.id)
        diff = self.amount - old_transaction.amount

        account_from = Account.find(self.account_from_id)
        account_to = Account.find(self.account_to_id)

        if !account_from.nil? && !account_to.nil?
          account_from.amount -= diff
          if account_from.valid?
            account_from.save

            account_to.amount += diff
            account_to.save
          else
            valid = false
            self.addNegativeAccountError
          end
        end
     else
       valid = false
     end
     return valid
  end

  def rollbackSumBetweenAccounts
    valid = true
    account_from = Account.find(self.account_from_id)
    account_to = Account.find(self.account_to_id)
    if !account_from.nil? && !account_to.nil?
      account_to.amount -= self.amount
      if(account_to.valid?)
        account_to.save

        account_from.amount += self.amount
        account_from.save
      else
        valid = false
        self.addNegativeAccountError
      end
    else
      valid = false
    end
    return valid
  end

  def transferSumFromAccountToCategory
    valid = true
    if self.checkForAccountFrom == true && self.checkForCategory == true
      account_from = Account.find(self.account_from_id)
      category = Category.find(self.category_id)
      if !account_from.nil? && !category.nil?
        account_from.amount -= self.amount
        if(account_from.valid?)
          account_from.save

          category.amount += self.amount
          category.save
        else
          valid = false
          self.addNegativeAccountError
        end
      end
    else
      valid = false
    end
    return valid
  end

  def changeSumFromAccountToCategory
     valid = true
     if self.checkForAccountFrom == true && self.checkForCategory == true
       old_transaction = Transaction.find(self.id)
       diff = self.amount - old_transaction.amount

       account_from = Account.find(self.account_from_id)
       category = Category.find(self.category_id)
       if !account_from.nil? && !category.nil?
         account_from.amount -= diff
         if(account_from.valid?)
           account_from.save

           category.amount += self.diff
           category.save
         else
           valid = false
           self.addNegativeAccountError
         end
       end
     else
       valid = false
     end
     return valid
  end

  def rollbackSumFromCategory
    valid = true
    account_from = Account.find(@transaction.account_from_id)
    if !account_from.nil?
      account_from.amount +=@transaction.amount
      if(account_from.valid?)
        account_from.save
      end
    else
      valid = false
    end
    return valid
  end
end
