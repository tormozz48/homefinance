class TransactionsController < ApplicationController
  before_filter :authenticate_user!

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

  def show
    @transaction = Transaction.find(params[:id])
    @transaction_type = @transaction.transaction_type
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: [@transaction, @transaction_type] }
    end
  end

  def new
    @transaction_type = params[:type]

    @transaction = Transaction.new(:transaction_type => @transaction_type, :amount => 0)

    @accounts = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(getAccountCardType, current_user.id, true)
    @cashes = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(getAccountCashType, current_user.id, true)
    @categories = Category.order("name ASC").find_all_by_user_id_and_enabled(current_user.id, true)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: [@transaction, @transaction_type, @accounts, @cashes, @categories] }
    end
  end

  def edit
    @transaction = Transaction.find(params[:id])
    @transaction_type = @transaction.transaction_type

    @accounts = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(getAccountCardType, current_user.id, true)
    @cashes = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(getAccountCashType, current_user.id, true)
    @categories = Category.order("name ASC").find_all_by_user_id_and_enabled(current_user.id, true)
  end

  def create
    @transaction = Transaction.new(params[:transaction])
    @transaction_type = @transaction.transaction_type

    account_from = nil
    account_to = nil
    category = nil
    valid = true

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
        if(account_from.valid?)
          account_from.save

          account_to.amount +=@transaction.amount
          account_to.save
        else
          valid = false
          @transaction.addNegativeAccountError
        end
      end
    elsif @transaction_type == getTransactionFromAccountToCategory ||
          @transaction_type == getTransactionFromCashToCategory
      account_from = Account.find(@transaction.account_from_id)
      category = Category.find(@transaction.category_id)
      if(!account_from.nil? && !category.nil?)
        account_from.amount -=@transaction.amount
        if(account_from.valid?)
          account_from.save

          category.amount +=@transaction.amount
          category.save
        else
          valid = false
          @transaction.addNegativeAccountError
        end
      end
    end

  if(current_user.nil? == false)
      @transaction.user = current_user
      respond_to do |format|
        if valid == true && @transaction.save
          format.html {redirect_to transactions_path(:type => @transaction_type)}
        else
          format.html { render action: "new" }
          format.json { render json: [@transaction.errors, @transaction_type], status: :unprocessable_entity }
        end
      end
    end
  end

  def update
    @transaction = Transaction.find(params[:id])
    @transaction_type = @transaction.transaction_type
    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        redirect_to {transactions_path(:type => @transaction_type)}
      else
        format.html { render action: "edit" }
        format.json { render json: [@transaction.errors, @transaction_type], status: :unprocessable_entity }
      end
    end
  end

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
