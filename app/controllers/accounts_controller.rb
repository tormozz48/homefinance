class AccountsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @account_type = params[:type]
  end

  def load
    account_type = params[:type]

    field = params[:field].nil? ? "name" : params[:field]
    direction = params[:direction].nil? ? "asc" : params[:direction]
    sortStr = field + " " + direction

    @accounts = Account.order(sortStr).find_all_by_account_type_and_user_id_and_enabled(account_type, current_user.id, true)
    render :partial => "accounts"
  end

  def sort
    respond_to do |format|
      format.html { redirect_to load_accounts_path(
                                    :type => params[:type],
                                    :field => params[:field],
                                    :direction => params[:direction])}
    end
  end

  def new
    @account_type = params[:type]
    @account = Account.new
    @account.account_type = @account_type
    @account.amount = 0
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: [@account, @account_type] }
    end
  end

  def edit
    @account_type = params[:type]
    @account = Account.find(params[:id])
    if(@account.user_id != current_user.id)
       redirect_to :back and return
    end
  end

  def create
    @account = Account.new(params[:account])
    @account_type = @account.account_type
    if(current_user.nil? == false)
      @account.user = current_user
      respond_to do |format|
        if @account.save
          format.html {redirect_to accounts_path(:type=> @account_type)}
        else
          format.html { render action: "new" }
          format.json { render json: [@account.errors, @account_type], status: :unprocessable_entity }
        end
      end
    end
  end

  def update
    @account = Account.find(params[:id])
    @account_type = @account.account_type
    if(@account.user_id == current_user.id)
    respond_to do |format|
        if @account.update_attributes(params[:account])
          format.html {redirect_to accounts_path(:type=> @account_type)}
        else
          format.html { render action: "edit" }
          format.json { render json: [@account.errors, @account_type], status: :unprocessable_entity }
        end
      end
    else
      redirect_to :back and return
    end
  end

  def destroy
    @account = Account.find(params[:id])
    account_type = @account.account_type
    if(@account.user_id == current_user.id)
      @account.enabled=false
      @account.save
      respond_to do |format|
        format.html { redirect_to accounts_url(:type => account_type) }
        format.json { head :no_content }
      end
    else
       redirect_to :back and return
    end
  end
end
