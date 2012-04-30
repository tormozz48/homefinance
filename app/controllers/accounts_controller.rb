class AccountsController < ApplicationController
  before_filter :authenticate_user!

  # GET /accounts
  # GET /accounts.json
  def index
    @account_type = params[:type]
    @accounts = Account.find_all_by_account_type(@account_type)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => [@accounts, @account_type] }
    end
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    @account_type = params[:type]
    @account = Account.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: [@account, @account_type] }
    end
  end

  # GET /accounts/new
  # GET /accounts/new.json
  def new
    @account_type = params[:type]
    @account = Account.new
    @account.account_type=@account_type
    @account.amount = 0
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: [@account, @account_type] }
    end
  end

  # GET /accounts/1/edit
  def edit
    @account_type = params[:type]
    @account = Account.find(params[:id])
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(params[:account])
    @account_type = @account.account_type
    if(current_user.nil? == false)
      @account.user = current_user
      respond_to do |format|
        if @account.save
          format.html { redirect_to @account,
                                    notice: @account.account_type == getAccountCardType ? t(:message_account_card_successfully_added) : t(:message_account_cash_successfully_added) }
          format.json { render json: @account, status: :created, location: @account }
        else
          format.html { render action: "new" }
          format.json { render json: [@account.errors, @account_type], status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.json
  def update
    @account = Account.find(params[:id])
    @account_type = @account.account_type
    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html { redirect_to @account,
                                  notice: @account.account_type == getAccountCardType ? t(:message_account_card_successfully_updated) : t(:message_account_cash_successfully_updated)  }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: [@account.errors, @account_type], status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_url }
      format.json { head :no_content }
    end
  end
end
