class AccountsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @account_type = params[:type]
    @field = session["account_field"]
    @direction = session["account_direction"]
    if !Account::ACCOUNT_TYPES.include? @account_type.to_i
      render_404
    end
  end

  def sort
    account_type = params[:type]
    field = params[:field].nil? ? "name" : params[:field]
    direction = params[:direction].nil? ? "asc" : params[:direction]

    session["category_field"] = field
    session["category_direction"] = direction

    sortStr = field + " " + direction

    @accounts = Account.order(sortStr).find_all_by_account_type_and_user_id_and_enabled(account_type, current_user.id, true)
    render :partial => "accounts"
  end

  def new
    account_type = params[:type]
    @account = Account.new
    @account.account_type = account_type
    @account.amount = 0
  end

  def edit
    @account = Account.find(params[:id])
    if(@account.user_id != current_user.id)
       redirect_to :back and return
    end
  end

  def create
    @account = Account.new(params[:account])
    @account_type = @account.account_type
    @account.user = current_user
    respond_to do |format|
      if @account.save
        flash[:notice] = @account_type == Account::ACCOUNT_CARD_TYPE ?
            I18n.t('notice.account.added') : I18n.t('notice.cash.added')
        format.html {redirect_to accounts_path(:type=> @account_type)}
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @account = Account.find(params[:id])
    if @account.nil?
      render_404 and return
    end
    @account_type = @account.account_type
    if(@account.user_id == current_user.id)
    respond_to do |format|
        if @account.update_attributes(params[:account])
          flash[:notice] = @account_type == Account::ACCOUNT_CARD_TYPE ?
              I18n.t('notice.account.changed') : I18n.t('notice.cash.changed')
          format.html {redirect_to accounts_path(:type=> @account_type)}
        else
          format.html { render action: "edit" }
        end
      end
    else
      redirect_to :back and return
    end
  end

  def destroy
    @account = Account.find(params[:id])
    if @account.nil?
      render_404 and return
    end
    account_type = @account.account_type
    if(@account.user_id == current_user.id)
      @account.update_attribute(:enabled, false)
      if @account.save
        flash[:notice] = account_type == Account::ACCOUNT_CARD_TYPE ?
            I18n.t('notice.account.deleted') : I18n.t('notice.cash.deleted')
      else
        flash[:notice] = account_type == Account::ACCOUNT_CARD_TYPE ?
            I18n.t('error.account.deleted') : I18n.t('error.cash.deleted')
      end
    else
      flash[:error] = account_type == Account::ACCOUNT_CARD_TYPE ?
          I18n.t('error.account.deleted') : I18n.t('error.cash.deleted')
    end
    redirect_to :back and return
  end
end
