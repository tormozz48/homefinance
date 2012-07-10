module StatisticsHelper
  def getTransactionTypesOptionList
    str = ""
    str += "<option value="+7.to_s(10)+">"+I18n.t(:menu_transaction_from_cash)+"</option>"
    str += "<option value="+2.to_s(10)+">"+I18n.t(:menu_transaction_from_account_to_cash)+"</option>"
    str += "<option value="+0.to_s(10)+">"+I18n.t(:menu_transaction_to_account)+"</option>"
    str += "<option value="+4.to_s(10)+">"+I18n.t(:menu_transaction_to_cash)+"</option>"
    str += "<option value="+6.to_s(10)+">"+I18n.t(:menu_transaction_from_cash_to_cash)+"</option>"
    str += "<option value="+3.to_s(10)+">"+I18n.t(:menu_transaction_from_account_to_category)+"</option>"
    str += "<option value="+1.to_s(10)+">"+I18n.t(:menu_transaction_from_account_to_account)+"</option>"
    str += "<option value="+5.to_s(10)+">"+I18n.t(:menu_transaction_from_cash_to_account)+"</option>"
    return str
  end

  def getTransactionTypesWithCategoriesOptionList
    str = ""
    str += "<option value="+7.to_s(10)+">"+I18n.t(:menu_transaction_from_cash)+"</option>"
    str += "<option value="+3.to_s(10)+">"+I18n.t(:menu_transaction_from_account_to_category)+"</option>"
    return str
  end

  def getCategoriesDisplayCountOptionList
    str = ""
    str += "<option>5</option>"
    str += "<option selected='selected'>10</option>"
    str += "<option>15</option>"
    str += "<option>20</option>"
    return str
  end
end
