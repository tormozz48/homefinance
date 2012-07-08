class ApplicationController < ActionController::Base
  protect_from_forgery

  #account types
  def getAccountCardType
    return 0
  end

  def getAccountCashType
    return 1
  end

  def getTransactionToAccount
    return 0
  end

  def getTransactionFromAccountToAccount
    return 1
  end

  def getTransactionFromAccountToCash
    return 2
  end

  def getTransactionFromAccountToCategory
    return 3
  end

  def getTransactionToCash
    return 4
  end

  def getTransactionFromCashToAccount
    return 5
  end

  def getTransactionFromCashToCash
    return 6
  end

  def getTransactionFromCashToCategory
    return 7
  end

  def edit
    @user = current_user
    respond_to do |format|
      format.html {render 'devise/user_profile'}
    end
  end

  def update
      @user = User.find(current_user.id)
      successfully_updated = @user.update_without_password(params[:user])
      if successfully_updated
        sign_in @user, :bypass => true
        redirect_to root_path
      else
        respond_to do |format|
          format.html { render 'devise/user_profile'}
          format.json { render json: [@user.errors], status: :unprocessable_entity }
        end
      end
  end

  def sign_with_social

  end
end
