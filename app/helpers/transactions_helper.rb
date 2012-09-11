module TransactionsHelper

  def getRowColorByDate(date)
    return "#"+{0 => "C34DFF", #sunday
                1 => "FF6A4D", #monday
                2 => "FFC34D", #tuesday
                3 => "E1FF4D", #wednesday
                4 => "88FF4D", #thursday
                5 => "4DE1FF", #friday
                6 => "4D88FF"  #saturday
    }[date.to_time().wday]
  end

  def getRowColorByDayOfWeek(dayOfWeek)
    return "#"+{0 => "C34DFF", #sunday
                1 => "FF6A4D", #monday
                2 => "FFC34D", #tuesday
                3 => "E1FF4D", #wednesday
                4 => "88FF4D", #thursday
                5 => "4DE1FF", #friday
                6 => "4D88FF"  #saturday
    }[dayOfWeek]
  end

  def getIndexTitle(transaction_type)
    return {Transaction::TRANSACTION_TO_ACCOUNT => I18n.t('list.transactions.to_account'),
            Transaction::TRANSACTION_FROM_ACCOUNT_TO_ACCOUNT => I18n.t('list.transactions.from_account.to_account'),
            Transaction::TRANSACTION_FROM_ACCOUNT_TO_CASH => I18n.t('list.transactions.from_account.to_cash'),
            Transaction::TRANSACTION_FROM_ACCOUNT_TO_CATEGORY => I18n.t('list.transactions.from_account.to_category'),
            Transaction::TRANSACTION_TO_CASH => I18n.t('list.transactions.to_cash'),
            Transaction::TRANSACTION_FROM_CASH_TO_ACCOUNT => I18n.t('list.transactions.from_cash.to_account'),
            Transaction::TRANSACTION_FROM_CASH_TO_CASH => I18n.t('list.transactions.from_cash.to_cash'),
            Transaction::TRANSACTION_FROM_CASH_TO_CATEGORY => I18n.t('list.transactions.from_cash.to_category')}[transaction_type]
  end

  def getNewTitle(transaction_type)
    return {Transaction::TRANSACTION_TO_ACCOUNT => I18n.t('form.title.new.transaction.to_account'),
            Transaction::TRANSACTION_FROM_ACCOUNT_TO_ACCOUNT => I18n.t('form.title.new.transaction.from_account.to_account'),
            Transaction::TRANSACTION_FROM_ACCOUNT_TO_CASH => I18n.t('form.title.new.transaction.from_account.to_cash'),
            Transaction::TRANSACTION_FROM_ACCOUNT_TO_CATEGORY => I18n.t('form.title.new.transaction.from_account.to_category'),
            Transaction::TRANSACTION_TO_CASH => I18n.t('form.title.new.transaction.to_cash'),
            Transaction::TRANSACTION_FROM_CASH_TO_ACCOUNT => I18n.t('form.title.new.transaction.from_cash.to_account'),
            Transaction::TRANSACTION_FROM_CASH_TO_CASH => I18n.t('form.title.new.transaction.from_cash.to_cash'),
            Transaction::TRANSACTION_FROM_CASH_TO_CATEGORY => I18n.t('form.title.new.transaction.from_cash.to_category')}[transaction_type]
  end

  def getEditTitle(transaction_type)
    return {Transaction::TRANSACTION_TO_ACCOUNT => I18n.t('form.title.edit.transaction.to_account'),
            Transaction::TRANSACTION_FROM_ACCOUNT_TO_ACCOUNT => I18n.t('form.title.edit.transaction.from_account.to_account'),
            Transaction::TRANSACTION_FROM_ACCOUNT_TO_CASH => I18n.t('form.title.edit.transaction.from_account.to_cash'),
            Transaction::TRANSACTION_FROM_ACCOUNT_TO_CATEGORY => I18n.t('form.title.edit.transaction.from_account.to_category'),
            Transaction::TRANSACTION_TO_CASH => I18n.t('form.title.edit.transaction.to_cash'),
            Transaction::TRANSACTION_FROM_CASH_TO_ACCOUNT => I18n.t('form.title.edit.transaction.from_cash.to_account'),
            Transaction::TRANSACTION_FROM_CASH_TO_CASH => I18n.t('form.title.edit.transaction.from_cash.to_cash'),
            Transaction::TRANSACTION_FROM_CASH_TO_CATEGORY => I18n.t('form.title.edit.transaction.from_cash.to_category')}[transaction_type]
  end

  def roundFloatTwoDigits(number)
    return (number * 100).to_i.to_f / 100
  end

  def createTransactionTableHeader(transaction_type)

    width = "20%"
    double_width = "40%"

    if transaction_type == Transaction::TRANSACTION_TO_ACCOUNT
      return content_tag(:th, I18n.t('field.transaction.account_to'), :width => double_width)
    elsif transaction_type == Transaction::TRANSACTION_FROM_ACCOUNT_TO_ACCOUNT
      return content_tag(:th, I18n.t('field.transaction.account_from'), :width => width) +
             content_tag(:th, I18n.t('field.transaction.account_to'), :width => width)
    elsif transaction_type == Transaction::TRANSACTION_FROM_ACCOUNT_TO_CASH
      return content_tag(:th, I18n.t('field.transaction.account_from'), :width => width) +
             content_tag(:th, I18n.t('field.transaction.cash_to'), :width => width)
    elsif transaction_type == Transaction::TRANSACTION_FROM_ACCOUNT_TO_CATEGORY
      return content_tag(:th, I18n.t('field.transaction.account_from'), :width => width) +
             content_tag(:th, I18n.t('field.transaction.category'), :width => width)
    elsif transaction_type == Transaction::TRANSACTION_TO_CASH
      return content_tag(:th, I18n.t('field.transaction.cash_to'), :width => double_width)
    elsif transaction_type == Transaction::TRANSACTION_FROM_CASH_TO_ACCOUNT
      return content_tag(:th, I18n.t('field.transaction.cash_from'), :width => width) +
             content_tag(:th, I18n.t('field.transaction.account_to'), :width => width)
    elsif transaction_type == Transaction::TRANSACTION_FROM_CASH_TO_CASH
      return content_tag(:th, I18n.t('field.transaction.cash_from'), :width => width) +
             content_tag(:th, I18n.t('field.transaction.cash_to'), :width => width)
    elsif transaction_type == Transaction::TRANSACTION_FROM_CASH_TO_CATEGORY
      return content_tag(:th, I18n.t('field.transaction.cash_from'), :width => width) +
             content_tag(:th, I18n.t('field.transaction.category'), :width => width)
    end
  end

  def getTransactionsSortingOptionList(v)
    return content_tag(:option, I18n.t('field.common.date'), :value =>"date", :selected => v == "date" ? "selected" : false) +
           content_tag(:option, I18n.t('field.transaction.summa'), :value =>"amount", :selected => v == "amount" ? "selected" : false) +
           content_tag(:option, I18n.t('field.transaction.comment'), :value =>"comment", :selected => v == "comment" ? "selected" : false)
  end
end
