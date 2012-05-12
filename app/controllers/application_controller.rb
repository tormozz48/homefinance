class ApplicationController < ActionController::Base
  protect_from_forgery

  #account types
  def getAccountCardType
    return 0
  end

  def getAccountCashType
    return 1
  end

  def getTransactionToAccount
    return 0
  end

  def getTransactionFromAccountToAccount
    return 1
  end

  def getTransactionFromAccountToCash
    return 2
  end

  def getTransactionFromAccountToCategory
    return 3
  end

  def getTransactionToCash
    return 4
  end

  def getTransactionFromCashToAccount
    return 5
  end

  def getTransactionFromCashToCash
    return 6
  end

  def getTransactionFromCashToCategory
    return 7
  end
end
