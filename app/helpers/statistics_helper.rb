module StatisticsHelper
  def getTransactionTypesOptionList
    return content_tag(:option, I18n.t('menu.transaction.from_cash.to_category'), :value => 7.to_s(10)) +
           content_tag(:option, I18n.t('menu.transaction.from_account.to_cash'), :value => 2.to_s(10)) +
           content_tag(:option, I18n.t('menu.transaction.to_account'), :value => 0.to_s(10)) +
           content_tag(:option, I18n.t('menu.transaction.to_cash'), :value => 4.to_s(10)) +
           content_tag(:option, I18n.t('menu.transaction.from_cash.to_cash'), :value => 6.to_s(10)) +
           content_tag(:option, I18n.t('menu.transaction.from_account.to_category'), :value => 3.to_s(10)) +
           content_tag(:option, I18n.t('menu.transaction.from_account.to_account'), :value => 1.to_s(10)) +
           content_tag(:option, I18n.t('menu.transaction.from_cash.to_account'), :value => 5.to_s(10))
  end

  def getTransactionTypesWithCategoriesOptionList
    return content_tag(:option, I18n.t('menu.transaction.from_cash.to_category'), :value => 7.to_s(10)) +
           content_tag(:option, I18n.t('menu.transaction.from_account.to_category'), :value => 3.to_s(10))
  end

  def getCategoriesDisplayCountOptionList
    return content_tag(:option, 5) +
           content_tag(:option, 10, :selected =>"selected") +
           content_tag(:option, 15) +
           content_tag(:option, 20)
  end
end
