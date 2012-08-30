module AccountsHelper
  def getAccountIndexTitle(type)
    return {Account::ACCOUNT_CARD_TYPE.to_s(10) => I18n.t('list.account.cards'),
            Account::ACCOUNT_CASH_TYPE.to_s(10) => I18n.t('list.account.cashes')}[type]
  end

  def getAccountAddTitle(type)
      return {Account::ACCOUNT_CARD_TYPE => I18n.t('form.title.new.account.card'),
              Account::ACCOUNT_CASH_TYPE => I18n.t('form.title.new.account.cash')}[type]
  end

  def getAccountEditTitle(type)
      return {Account::ACCOUNT_CARD_TYPE => I18n.t('form.title.edit.account.card'),
              Account::ACCOUNT_CASH_TYPE => I18n.t('form.title.edit.account.cash')}[type]

  end

  def getAccountsSortingOptionList
      return content_tag(:option, I18n.t('field.common.name'), :value =>"name") +
             content_tag(:option, I18n.t('field.common.description'), :value =>"description") +
             content_tag(:option, I18n.t('field.account.amount'), :value =>"amount")
  end
end
