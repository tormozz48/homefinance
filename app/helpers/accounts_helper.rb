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

  def getAccountsSortingOptionList(v)
      return content_tag(:option, I18n.t('field.common.name'), :value =>"name", :selected => v == "name" ? "selected" : false) +
             content_tag(:option, I18n.t('field.common.description'), :value =>"description", :selected => v == "description" ? "selected" : false) +
             content_tag(:option, I18n.t('field.account.amount'), :value =>"amount", :selected => v == "amount" ? "selected" : false)
  end
end
