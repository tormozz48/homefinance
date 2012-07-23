class Transaction < ActiveRecord::Base
  #paginates_per 50

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
    if(self.account_from_id.nil?)
      self.addEmptyAccountFromError
      return false
    else
      return true
    end
  end

  def checkForAccountTo
    if(self.account_to_id.nil?)
      self.addEmptyAccountToError
      return false
    else
      return true
    end
  end

  def checkForCategory
    if(self.category_id.nil?)
      self.addEmptyCategoryError
      return false
    else
      return true
    end
  end

  def addNegativeAccountError
    errors[:account_from] = I18n.t('message.error.account.negative')
  end

  def addEmptyAccountFromError
    errors[:account_from] = I18n.t('message.error.account.empty')
  end

  def addEmptyAccountToError
    errors[:account_to] = I18n.t('message.error.account.empty')
  end

  def addEmptyCategoryError
    errors[:category] = I18n.t('message.error.category.empty')
  end

  def transferSumToAccount
    if self.checkForAccountTo == true
      account_to = Account.find(self.account_to_id)
      if !account_to.nil?
        account_to.amount += self.amount
        account_to.save
      end
      return true
    else
      return false
    end
  end

  def changeSumToAccount
    if self.checkForAccountTo == true
      old_transaction = Transaction.find(self.id)
      diff = self.amount - old_transaction.amount
      account_to = Account.find(self.account_to_id)
      if !account_to.nil?
        account_to.amount += diff
        account_to.save
      end
      return true
    else
      return false
    end
  end

  def rollbackSumFromAccount
    account_to = Account.find(self.account_to_id)
    if !account_to.nil?
      account_to.amount -= self.amount
      if account_to.valid?
        account_to.save
      else
        self.addNegativeAccountError
        return false
      end
      return true
    else
      return false
    end
  end

  def transferSumBetweenAccounts
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
          self.addNegativeAccountError
          return false
        end
      end
      return true
    else
      return false
    end
  end

  def changeSumBetweenAccounts
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
            return true
          else
            self.addNegativeAccountError
            return false
          end
        else
          return false
        end
     else
       return false
     end
  end

  def rollbackSumBetweenAccounts
    account_from = Account.find(self.account_from_id)
    account_to = Account.find(self.account_to_id)
    if !account_from.nil? && !account_to.nil?
      account_to.amount -= self.amount
      if(account_to.valid?)
        account_to.save
        account_from.amount += self.amount
        account_from.save
        return true
      else
        self.addNegativeAccountError
        return false
      end
    else
      return false
    end
  end

  def transferSumFromAccountToCategory
    if self.checkForAccountFrom == true && self.checkForCategory == true
      account_from = Account.find(self.account_from_id)
      category = Category.find(self.category_id)
      if !account_from.nil? && !category.nil?
        account_from.amount -= self.amount
        if(account_from.valid?)
          account_from.save
          category.amount += self.amount
          category.save
          return true
        else
          self.addNegativeAccountError
          return false
        end
      else
        return false
      end
    else
      return false
    end
  end

  def changeSumFromAccountToCategory
     if self.checkForAccountFrom == true && self.checkForCategory == true
       old_transaction = Transaction.find(self.id)
       diff = self.amount - old_transaction.amount

       account_from = Account.find(self.account_from_id)
       category = Category.find(self.category_id)
       if !account_from.nil? && !category.nil?
         account_from.amount -= diff
         if(account_from.valid?)
           account_from.save
           category.amount += diff
           category.save
           return true
         else
           self.addNegativeAccountError
           return false
         end
       else
         return false
       end
     else
       return false
     end
  end

  def rollbackSumFromCategory
    account_from = Account.find(self.account_from_id)
    if !account_from.nil?
      account_from.amount += self.amount
      account_from.save
      return true
    else
      return false
    end
  end
end
