module AccountsHelper
  #account types
  def getAccountCardType
    return 0
  end

  def getAccountCashType
    return 1
  end

  def getIndexTitle(type)
    if type == getAccountCardType.to_s(10)
      return I18n.t('list.account.cards')
    elsif type == getAccountCashType.to_s(10)
      return I18n.t('list.account.cashes')
    end
  end

  def getAddButtonLink(type)
    title = ""
    if @account_type == getAccountCardType.to_s(10)
      title = I18n.t('add.account.card')
    elsif @account_type == getAccountCashType.to_s(10)
      title = I18n.t('add.account.cash')
    end
    return link_to title , new_account_path(:type => @account_type), :class => "link"
  end

  def getAddTitle(type)
    if type == getAccountCardType.to_s(10)
      return I18n.t('form.title.new.account.card')
    elsif type == getAccountCashType.to_s(10)
      return I18n.t('form.title.new.account.cash')
    end
  end

  def getEditTitle(type)
    if type == getAccountCardType.to_s(10)
      return I18n.t('form.title.edit.account.card')
    elsif type == getAccountCashType.to_s(10)
      return I18n.t('form.title.edit.account.cash')
    end
  end
end
