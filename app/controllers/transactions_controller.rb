class TransactionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @transaction_type = params[:type]
    if @transaction_type.nil?
      redirect_to transactions_path(:type => getTransactionFromCashToCategory) and return
    end
    @transactions = Transaction.order("created_at DESC").find_all_by_transaction_type_and_user_id(@transaction_type, current_user.id)
  end

  def show

  end

  def new
    @task_new = true
    @transaction_type = params[:type]
    @transaction = Transaction.new(:transaction_type => @transaction_type, :amount => 0)

    @accounts = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(getAccountCardType, current_user.id, true)
    @cashes = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(getAccountCashType, current_user.id, true)
    @categories = Category.order("name ASC").find_all_by_user_id_and_enabled(current_user.id, true)
  end

  def edit
    @transaction = Transaction.find(params[:id])
    @transaction_type = @transaction.transaction_type
    @task_new = false
  end

  def create
    @transaction = Transaction.new(params[:transaction])
    @transaction_type = @transaction.transaction_type

    valid = true
    if(@transaction.valid?)
      if @transaction_type == getTransactionToAccount ||
         @transaction_type == getTransactionToCash
        valid = @transaction.transferSumToAccount
      elsif @transaction_type == getTransactionFromAccountToAccount ||
            @transaction_type == getTransactionFromAccountToCash ||
            @transaction_type == getTransactionFromCashToAccount ||
            @transaction_type == getTransactionFromCashToCash
        valid = @transaction.transferSumBetweenAccounts
      elsif @transaction_type == getTransactionFromAccountToCategory ||
            @transaction_type == getTransactionFromCashToCategory
        valid = @transaction.transferSumFromAccountToCategory
      end
    else
      valid = false
    end
    if(current_user.nil? == false)
      @transaction.user = current_user
      respond_to do |format|
        if valid == true && @transaction.save
          format.html {redirect_to transactions_path(:type => @transaction_type)}
        else
          @task_new = true
          @accounts = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(getAccountCardType, current_user.id, true)
          @cashes = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(getAccountCashType, current_user.id, true)
          @categories = Category.order("name ASC").find_all_by_user_id_and_enabled(current_user.id, true)

          format.html { render action: "new" }
          format.json { render json: [@transaction.errors, @transaction_type, @task_new, @accounts, @cashes, @categories], status: :unprocessable_entity }
        end
      end
    end
  end

  def update
    @transaction = Transaction.find(params[:id])
    @transaction_type = @transaction.transaction_type
    p = params[:transaction]
    @transaction.amount = p[:amount]
    valid = true

    if @transaction_type == getTransactionToAccount ||
        @transaction_type == getTransactionToCash
      valid = @transaction.changeSumToAccount
    elsif @transaction_type == getTransactionFromAccountToAccount ||
        @transaction_type == getTransactionFromAccountToCash ||
        @transaction_type == getTransactionFromCashToAccount ||
        @transaction_type == getTransactionFromCashToCash
      valid = @transaction.changeSumBetweenAccounts
    elsif @transaction_type == getTransactionFromAccountToCategory ||
        @transaction_type == getTransactionFromCashToCategory
      valid = @transaction.changeSumFromAccountToCategory
    end

    respond_to do |format|
      if valid == true && @transaction.update_attributes(params[:transaction])
        format.html { redirect_to transactions_path(:type => @transaction_type)}
      else
        @task_new = false
        format.html { render action: "edit" }
        format.json { render json: [@transaction.errors, @transaction_type, @task_new], status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction_type = @transaction.transaction_type
    valid = true

    if @transaction_type == getTransactionToAccount ||
       @transaction_type == getTransactionToCash
      valid = @transaction.rollbackSumFromAccount
    elsif @transaction_type == getTransactionFromAccountToAccount ||
        @transaction_type == getTransactionFromAccountToCash ||
        @transaction_type == getTransactionFromCashToAccount ||
        @transaction_type == getTransactionFromCashToCash
      valid = @transaction.rollbackSumBetweenAccounts
    elsif @transaction_type == getTransactionFromAccountToCategory ||
        @transaction_type == getTransactionFromCashToCategory
      valid = @transaction.rollbackSumFromCategory
    end

    if valid == true
      @transaction.destroy
      respond_to do |format|
        format.html { redirect_to transactions_path(:type => @transaction_type) }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to transactions_path(:type => @transaction_type), :alert => @transaction.errors }
        format.json { head :no_content }
      end
    end
  end
end
