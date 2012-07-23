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
    return {0 => I18n.t('list.transactions.to_account'),
            1 => I18n.t('list.transactions.from_account.to_account'),
            2 => I18n.t('list.transactions.from_account.to_cash'),
            3 => I18n.t('list.transactions.from_account.to_category'),
            4 => I18n.t('list.transactions.to_cash'),
            5 => I18n.t('list.transactions.from_cash.to_account'),
            6 => I18n.t('list.transactions.from_cash.to_cash'),
            7 => I18n.t('list.transactions.from_cash.to_category')}[transaction_type]
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
    return {0 => I18n.t('form.title.edit.transaction.to_account'),
            1 => I18n.t('form.title.edit.transaction.from_account.to_account'),
            2 => I18n.t('form.title.edit.transaction.from_account.to_cash'),
            3 => I18n.t('form.title.edit.transaction.from_account.to_category'),
            4 => I18n.t('form.title.edit.transaction.to_cash'),
            5 => I18n.t('form.title.edit.transaction.from_cash.to_account'),
            6 => I18n.t('form.title.edit.transaction.from_cash.to_cash'),
            7 => I18n.t('form.title.edit.transaction.from_cash.to_category')}[transaction_type]
  end

  def roundFloatTwoDigits(number)
    return (number * 100).to_i.to_f / 100
  end

  def createTransactionTableHeader(transaction_type)
    if transaction_type == getTransactionToAccount
      return content_tag(:th, I18n.t('field.transaction.account_to'), :class => "header-transaction-account")
    elsif transaction_type == getTransactionFromAccountToAccount
      return content_tag(:th, I18n.t('field.transaction.account_from'), :class => "header-transaction-account") +
             content_tag(:th, I18n.t('field.transaction.account_to'), :class => "header-transaction-account")
    elsif transaction_type == getTransactionFromAccountToCash
      return content_tag(:th, I18n.t('field.transaction.account_from'), :class => "header-transaction-account") +
             content_tag(:th, I18n.t('field.transaction.cash_to'), :class => "header-transaction-account")
    elsif transaction_type == getTransactionFromAccountToCategory
      return content_tag(:th, I18n.t('field.transaction.account_from'), :class => "header-transaction-account") +
             content_tag(:th, I18n.t('field.transaction.category'), :class => "header-transaction-account")
    elsif transaction_type == getTransactionToCash
      return content_tag(:th, I18n.t('field.transaction.cash_to'), :class => "header-transaction-account")
    elsif transaction_type == getTransactionFromCashToAccount
      return content_tag(:th, I18n.t('field.transaction.cash_from'), :class => "header-transaction-account") +
             content_tag(:th, I18n.t('field.transaction.account_to'), :class => "header-transaction-account")
    elsif transaction_type == getTransactionFromCashToCash
      return content_tag(:th, I18n.t('field.transaction.cash_from'), :class => "header-transaction-account") +
             content_tag(:th, I18n.t('field.transaction.cash_to'), :class => "header-transaction-account")
    elsif transaction_type == getTransactionFromCashToCategory
      return content_tag(:th, I18n.t('field.transaction.cash_from'), :class => "header-transaction-account") +
             content_tag(:th, I18n.t('field.transaction.category'), :class => "header-transaction-account")
    end
  end

  def getTransactionsSortingOptionList(transaction_type)
    str = ""
    str += "<option value='date'>"+I18n.t('field.common.date')+"</option>"
    str += "<option value='amount'>"+I18n.t('field.transaction.summa')+"</option>"
    str += "<option value='comment'>"+I18n.t('field.transaction.comment')+"</option>"
    return str
  end
end
