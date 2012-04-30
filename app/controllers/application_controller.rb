class ApplicationController < ActionController::Base
  protect_from_forgery

  #account types
  def getAccountCardType
    return 0
  end

  def getAccountCashType
    return 1
  end

end
