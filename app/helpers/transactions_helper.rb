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
    return {0.to_s(10) => I18n.t(:transactions_to_account_list),
            1.to_s(10) => I18n.t(:transactions_from_account_to_account_list),
            2.to_s(10) => I18n.t(:transactions_from_account_to_cash_list),
            3.to_s(10) => I18n.t(:transactions_from_account_to_category_list),
            4.to_s(10) => I18n.t(:transactions_to_cash_list),
            5.to_s(10) => I18n.t(:transactions_from_cash_to_account_list),
            6.to_s(10) => I18n.t(:transactions_from_cash_to_cash_list),
            7.to_s(10) => I18n.t(:transactions_from_cash_to_category_list)}[transaction_type]
  end

  def getNewTitle(transaction_type)
    return {0.to_s(10) => I18n.t(:form_new_transaction_to_account_title),
            1.to_s(10) => I18n.t(:form_new_transaction_from_account_to_account_title),
            2.to_s(10) => I18n.t(:form_new_transaction_from_account_to_cash_title),
            3.to_s(10) => I18n.t(:form_new_transaction_from_account_to_category_title),
            4.to_s(10) => I18n.t(:form_new_transaction_to_cash_title),
            5.to_s(10) => I18n.t(:form_new_transaction_from_cash_to_account_title),
            6.to_s(10) => I18n.t(:form_new_transaction_from_cash_to_cash_title),
            7.to_s(10) => I18n.t(:form_new_transaction_from_cash_to_category_title)}[transaction_type]
  end

  def getEditTitle(transaction_type)
    transaction_type
    return {0 => I18n.t(:form_edit_transaction_to_account_title),
            1 => I18n.t(:form_edit_transaction_from_account_to_account_title),
            2 => I18n.t(:form_edit_transaction_from_account_to_cash_title),
            3 => I18n.t(:form_edit_transaction_from_account_to_category_title),
            4 => I18n.t(:form_edit_transaction_to_cash_title),
            5 => I18n.t(:form_edit_transaction_from_cash_to_account_title),
            6 => I18n.t(:form_edit_transaction_from_cash_to_cash_title),
            7 => I18n.t(:form_edit_transaction_from_cash_to_category_title)}[transaction_type]
  end
end
