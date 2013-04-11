module TransactionsHelper

  def get_row_color_by_date(date)
    '#' + {0 => 'C34DFF', #sunday
           1 => 'FF6A4D', #monday
           2 => 'FFC34D', #tuesday
           3 => 'E1FF4D', #wednesday
           4 => '88FF4D', #thursday
           5 => '4DE1FF', #friday
           6 => '4D88FF'  #saturday
    }[date.to_time().wday]
  end

  def get_row_color_by_day(day)
    '#'+ {0 => 'C34DFF', #sunday
          1 => 'FF6A4D', #monday
          2 => 'FFC34D', #tuesday
          3 => 'E1FF4D', #wednesday
          4 => '88FF4D', #thursday
          5 => '4DE1FF', #friday
          6 => '4D88FF'  #saturday
    }[day]
  end

  def get_index_title(type)
   {Transaction::TR_TO_ACCOUNT => I18n.t('list.transactions.to_account'),
    Transaction::TR_FROM_ACCOUNT_TO_ACCOUNT => I18n.t('list.transactions.from_account.to_account'),
    Transaction::TR_FROM_ACCOUNT_TO_CASH => I18n.t('list.transactions.from_account.to_cash'),
    Transaction::TR_FROM_ACCOUNT_TO_CATEGORY => I18n.t('list.transactions.from_account.to_category'),
    Transaction::TR_TO_CASH => I18n.t('list.transactions.to_cash'),
    Transaction::TR_FROM_CASH_TO_ACCOUNT => I18n.t('list.transactions.from_cash.to_account'),
    Transaction::TR_FROM_CASH_TO_CASH => I18n.t('list.transactions.from_cash.to_cash'),
    Transaction::TR_FROM_CASH_TO_CATEGORY => I18n.t('list.transactions.from_cash.to_category')}[type]
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

    case type
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

  def get_sorting_options(v)
     content_tag(:option, I18n.t('field.common.date'), :value =>'date', :selected => v == 'date' ? 'selected' : false) +
     content_tag(:option, I18n.t('field.transaction.summa'), :value =>'amount', :selected => v == 'amount' ? 'selected' : false) +
     content_tag(:option, I18n.t('field.transaction.comment'), :value =>'comment', :selected => v == 'comment' ? 'selected' : false)
  end
end
