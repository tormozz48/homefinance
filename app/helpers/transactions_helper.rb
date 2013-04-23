module TransactionsHelper

  def get_row_color_by_date(date)
    '#' + {0 => 'FF66FF', #sunday
           1 => 'FFCCCC', #monday
           2 => 'FFCC88', #tuesday
           3 => 'E1FF4D', #wednesday
           4 => 'BBFFBB', #thursday
           5 => '4DE1FF', #friday
           6 => '66AAFF'  #saturday
    }[date.to_time().wday]
  end

  def get_row_color_by_day(day)
    '#'+ {0 => 'FF66FF', #sunday
          1 => 'FFCCCC', #monday
          2 => 'FFCC88', #tuesday
          3 => 'E1FF4D', #wednesday
          4 => 'BBFFBB', #thursday
          5 => '4DE1FF', #friday
          6 => '66AAFF'  #saturday
    }[day]
  end

  def get_new_title(type)
    {Transaction::TR_TO_ACCOUNT => I18n.t('form.title.new.transaction.to_account'),
     Transaction::TR_FROM_ACCOUNT_TO_ACCOUNT => I18n.t('form.title.new.transaction.from_account.to_account'),
     Transaction::TR_FROM_ACCOUNT_TO_CASH => I18n.t('form.title.new.transaction.from_account.to_cash'),
     Transaction::TR_FROM_ACCOUNT_TO_CATEGORY => I18n.t('form.title.new.transaction.from_account.to_category'),
     Transaction::TR_TO_CASH => I18n.t('form.title.new.transaction.to_cash'),
     Transaction::TR_FROM_CASH_TO_ACCOUNT => I18n.t('form.title.new.transaction.from_cash.to_account'),
     Transaction::TR_FROM_CASH_TO_CASH => I18n.t('form.title.new.transaction.from_cash.to_cash'),
     Transaction::TR_FROM_CASH_TO_CATEGORY => I18n.t('form.title.new.transaction.from_cash.to_category')}[type]
  end

  def get_edit_title(type)
    {Transaction::TR_TO_ACCOUNT => I18n.t('form.title.edit.transaction.to_account'),
     Transaction::TR_FROM_ACCOUNT_TO_ACCOUNT => I18n.t('form.title.edit.transaction.from_account.to_account'),
     Transaction::TR_FROM_ACCOUNT_TO_CASH => I18n.t('form.title.edit.transaction.from_account.to_cash'),
     Transaction::TR_FROM_ACCOUNT_TO_CATEGORY => I18n.t('form.title.edit.transaction.from_account.to_category'),
     Transaction::TR_TO_CASH => I18n.t('form.title.edit.transaction.to_cash'),
     Transaction::TR_FROM_CASH_TO_ACCOUNT => I18n.t('form.title.edit.transaction.from_cash.to_account'),
     Transaction::TR_FROM_CASH_TO_CASH => I18n.t('form.title.edit.transaction.from_cash.to_cash'),
     Transaction::TR_FROM_CASH_TO_CATEGORY => I18n.t('form.title.edit.transaction.from_cash.to_category')}[type]
  end

  def round_float(number)
    (number * 100).to_i.to_f / 100
  end

  def create_table_header(type)

    width = '20%'
    double_width = '40%'

    case type.to_i
    when Transaction::TR_TO_ACCOUNT
       content_tag(:th, I18n.t('field.transaction.account_to'), :width => double_width)
    when Transaction::TR_FROM_ACCOUNT_TO_ACCOUNT
       content_tag(:th, I18n.t('field.transaction.account_from'), :width => width) +
       content_tag(:th, I18n.t('field.transaction.account_to'), :width => width)
    when Transaction::TR_FROM_ACCOUNT_TO_CASH
       content_tag(:th, I18n.t('field.transaction.account_from'), :width => width) +
       content_tag(:th, I18n.t('field.transaction.cash_to'), :width => width)
    when Transaction::TR_FROM_ACCOUNT_TO_CATEGORY
       content_tag(:th, I18n.t('field.transaction.account_from'), :width => width) +
       content_tag(:th, I18n.t('field.transaction.category'), :width => width)
    when Transaction::TR_TO_CASH
       content_tag(:th, I18n.t('field.transaction.cash_to'), :width => double_width)
    when Transaction::TR_FROM_CASH_TO_ACCOUNT
       content_tag(:th, I18n.t('field.transaction.cash_from'), :width => width) +
       content_tag(:th, I18n.t('field.transaction.account_to'), :width => width)
    when Transaction::TR_FROM_CASH_TO_CASH
       content_tag(:th, I18n.t('field.transaction.cash_from'), :width => width) +
       content_tag(:th, I18n.t('field.transaction.cash_to'), :width => width)
    else Transaction::TR_FROM_CASH_TO_CATEGORY
       content_tag(:th, I18n.t('field.transaction.cash_from'), :width => width) +
       content_tag(:th, I18n.t('field.transaction.category'), :width => width)
    end
  end

  def get_row_class(transaction)
    unless transaction.transaction_type.in?(Transaction::TR_GROUP_TO_CATEGORY)
      return
    end
    amount = transaction.amount
    if amount <= 100
       'info'
    elsif amount > 100 && amount <= 1000
       'success'
    elsif amount > 1000 && amount <= 5000
       'warning'
    else
       'error'
    end
  end
end
