class TransactionsController < ApplicationController
  before_filter :authenticate_user!

  # GET /transactions
  # GET /transactions.json
  def index
    @transaction_type = params[:type]
    if @transaction_type.nil?
      redirect_to transactions_path(:type => getTransactionFromCashToCategory) and return
    end
    @transactions = Transaction.order("created_at DESC").find_all_by_transaction_type_and_user_id(@transaction_type, current_user.id)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: [@transactions, @transaction_type] }
    end
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
    @transaction = Transaction.find(params[:id])
    @transaction_type = @transaction.transaction_type
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: [@transaction, @transaction_type] }
    end
  end

  # GET /transactions/new
  # GET /transactions/new.json
  def new
    @transaction_type = params[:type]

    @transaction = Transaction.new(:transaction_type => @transaction_type, :amount => 0)

    @accounts = Account.order("name ASC").find_all_by_account_type_and_user_id(getAccountCardType, current_user.id)
    @cashes = Account.order("name ASC").find_all_by_account_type_and_user_id(getAccountCashType, current_user.id)
    @categories = Category.order("name ASC").find_all_by_user_id(current_user.id)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: [@transaction, @transaction_type, @accounts, @cashes, @categories] }
    end
  end

  # GET /transactions/1/edit
  def edit
    @transaction = Transaction.find(params[:id])
    @transaction_type = @transaction.transaction_type

    @accounts = Account.order("name ASC").find_all_by_account_type_and_user_id(getAccountCardType, current_user.id)
    @cashes = Account.order("name ASC").find_all_by_account_type_and_user_id(getAccountCashType, current_user.id)
    @categories = Category.order("name ASC").find_all_by_user_id(current_user.id)
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = Transaction.new(params[:transaction])
    @transaction_type = @transaction.transaction_type

    account_from = nil
    account_to = nil
    category = nil

    if @transaction_type == getTransactionToAccount ||
       @transaction_type == getTransactionToCash
      account_to = Account.find(@transaction.account_to_id)
      if(!account_to.nil?)
         account_to.amount +=@transaction.amount
         account_to.save
      end
    elsif @transaction_type == getTransactionFromAccountToAccount ||
          @transaction_type == getTransactionFromAccountToCash ||
          @transaction_type == getTransactionFromCashToAccount ||
          @transaction_type == getTransactionFromCashToCash
      account_from = Account.find(@transaction.account_from_id)
      account_to = Account.find(@transaction.account_to_id)
      if(!account_from.nil? && !account_to.nil?)
        account_from.amount -=@transaction.amount
        account_from.save!

        account_to.amount +=@transaction.amount
        account_to.save
      end
    elsif @transaction_type == getTransactionFromAccountToCategory ||
          @transaction_type == getTransactionFromCashToCategory
      account_from = Account.find(@transaction.account_from_id)
      category = Category.find(@transaction.category_id)
      if(!account_from.nil? && !category.nil?)
        account_from.amount -=@transaction.amount
        account_from.save

        category.amount +=@transaction.amount
        category.save
      end
    end

  if(current_user.nil? == false)
      @transaction.user = current_user
      respond_to do |format|
        if @transaction.save
          redirect_to transactions_path(:type => @transaction_type)
        else
          format.html { render action: "new" }
          format.json { render json: [@transaction.errors, @transaction_type], status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /transactions/1
  # PUT /transactions/1.json
  def update
    @transaction = Transaction.find(params[:id])
    @transaction_type = @transaction.transaction_type
    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        redirect_to transactions_path(:type => @transaction_type)
      else
        format.html { render action: "edit" }
        format.json { render json: [@transaction.errors, @transaction_type], status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction_type = @transaction.transaction_type
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to transactions_path(:type => @transaction_type) }
      format.json { head :no_content }
    end
  end
end
