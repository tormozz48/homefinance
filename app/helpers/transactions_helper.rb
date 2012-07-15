module TransactionsHelper


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

  def getRowColorByDate(date)
    return "#"+{0 => "C34DFF",
                1 => "FF6A4D",
                2 => "FFC34D",
                3 => "E1FF4D",
                4 => "88FF4D",
                5 => "4DE1FF",
                6 => "4D88FF"}[date.to_time().wday]
  end

  def getIndexTitle(transaction_type)
    return {0.to_s(10) => I18n.t('list.transactions.to_account'),
            1.to_s(10) => I18n.t('list.transactions.from_account.to_account'),
            2.to_s(10) => I18n.t('list.transactions.from_account.to_cash'),
            3.to_s(10) => I18n.t('list.transactions.from_account.to_category'),
            4.to_s(10) => I18n.t('list.transactions.to_cash'),
            5.to_s(10) => I18n.t('list.transactions.from_cash.to_account'),
            6.to_s(10) => I18n.t('list.transactions.from_cash.to_cash'),
            7.to_s(10) => I18n.t('list.transactions.from_cash.to_category')}[transaction_type]
  end

  def getNewTitle(transaction_type)
    return {0 => I18n.t('form.title.new.transaction.to_account'),
            1 => I18n.t('form.title.new.transaction.from_account.to_account'),
            2 => I18n.t('form.title.new.transaction.from_account.to_cash'),
            3 => I18n.t('form.title.new.transaction.from_account.to_category'),
            4 => I18n.t('form.title.new.transaction.to_cash'),
            5 => I18n.t('form.title.new.transaction.from_cash.to_account'),
            6 => I18n.t('form.title.new.transaction.from_cash.to_cash'),
            7 => I18n.t('form.title.new.transaction.from_cash.to_category')}[transaction_type]
  end

  def getEditTitle(transaction_type)
    transaction_type
    return {0 => I18n.t('form.title.edit.transaction.to_account'),
            1 => I18n.t('form.title.edit.transaction.from_account.to_account'),
            2 => I18n.t('form.title.edit.transaction.from_account.to_cash'),
            3 => I18n.t('form.title.edit.transaction.from_account.to_category'),
            4 => I18n.t('form.title.edit.transaction.to_cash'),
            5 => I18n.t('form.title.edit.transaction.from_cash.to_account'),
            6 => I18n.t('form.title.edit.transaction.from_cash.to_cash'),
            7 => I18n.t('form.title.edit.transaction.from_cash.to_category')}[transaction_type]
  end
end
