module AccountsHelper
  #account types
  def getAccountCardType
    return 0
  end

  def getAccountCashType
    return 1
  end

  def getAccountIndexTitle(type)
    if type == getAccountCardType.to_s(10)
      return I18n.t('list.account.cards')
    elsif type == getAccountCashType.to_s(10)
      return I18n.t('list.account.cashes')
    end
  end

  def getAddButtonLink(type)
    return link_to I18n.t('add.item') , new_account_path(:type => @account_type), :class => "link"
  end

  def getAddTitle(type)
    if type == getAccountCardType
      return I18n.t('form.title.new.account.card')
    elsif type == getAccountCashType
      return I18n.t('form.title.new.account.cash')
    end
  end

  def getAccountEditTitle(type)
    if type == getAccountCardType
      return I18n.t('form.title.edit.account.card')
    elsif type == getAccountCashType
      return I18n.t('form.title.edit.account.cash')
    end
  end

  def getAccountsSortingOptionList
    str = ""
    str += "<option value='name'>"+I18n.t('field.common.name')+"</option>"
    str += "<option value='description'>"+I18n.t('field.common.description')+"</option>"
    str += "<option value='amount'>"+I18n.t('field.account.amount')+"</option>"
    return str
  end
end
