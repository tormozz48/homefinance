module AccountsHelper
  def get_account_index_title(type)
      {Account::ACCOUNT_CARD_TYPE => I18n.t('list.account.cards'),
       Account::ACCOUNT_CASH_TYPE => I18n.t('list.account.cashes')}[type.to_i]
  end

  def get_account_add_title(type)
      {Account::ACCOUNT_CARD_TYPE => I18n.t('form.title.new.account.card'),
       Account::ACCOUNT_CASH_TYPE => I18n.t('form.title.new.account.cash')}[type.to_i]
  end

  def get_account_edit_title(type)
      {Account::ACCOUNT_CARD_TYPE => I18n.t('form.title.edit.account.card'),
       Account::ACCOUNT_CASH_TYPE => I18n.t('form.title.edit.account.cash')}[type.to_i]
  end
end
