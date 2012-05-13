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
      return I18n.t(:account_cards_list)
    elsif type == getAccountCashType.to_s(10)
      return I18n.t(:account_cashes_list)
    end
  end

  def getAddButtonLink(type)
    title = ""
    if @account_type == getAccountCardType.to_s(10)
      title = I18n.t(:add_new_account_card)
    elsif @account_type == getAccountCashType.to_s(10)
      title = I18n.t(:add_new_account_cash)
    end
    return link_to title , new_account_path(:type => @account_type), :class => "link"
  end

  def getAddTitle(type)
    if type == getAccountCardType.to_s(10)
      return I18n.t(:form_new_account_card_title)
    elsif type == getAccountCashType.to_s(10)
      return I18n.t(:form_new_account_cash_title)
    end
  end

  def getEditTitle(type)
    if type == getAccountCardType.to_s(10)
      return I18n.t(:form_edit_account_card_title)
    elsif type == getAccountCashType.to_s(10)
      return I18n.t(:form_edit_account_cash_title)
    end
  end
end
