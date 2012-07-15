class TransactionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @date_from = params[:date_from].nil? ? 1.year.ago.to_date : params[:date_from]
    @date_to = params[:date_to].nil? ? Date.today : params[:date_to]
    @category_id = params[:category]

    if params[:type].nil?
      redirect_to transactions_path(:type => getTransactionFromCashToCategory) and return
    else
      @transaction_type = params[:type]
    end
    session[:page] = params[:page].nil? ? 1 : params[:page]
    if !@category_id.nil? && (@transaction_type == getTransactionFromAccountToCategory.to_s(10) ||
                              @transaction_type == getTransactionFromCashToCategory.to_s(10))
      @transactions = Transaction.where("transaction_type = ? and user_id = ? and enabled = ? and category_id = ? and date between ? and ?",
                                        @transaction_type, current_user.id, true, @category_id, @date_from, @date_to).order("date DESC, id DESC").page(session[:page])
    else
      @transactions = Transaction.where("transaction_type = ? and user_id = ? and enabled = ? and date between ? and ?",
                                        @transaction_type, current_user.id, true, @date_from, @date_to).order("date DESC, id DESC").page(session[:page])
    end
    @categories = Category.where("enabled = true").order("name asc")
  end

  def show

  end

  def new
    @transaction = Transaction.new(:transaction_type => params[:type], :amount => 0, :date => Date.today)
    @accounts = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(getAccountCardType, current_user.id, true)
    @cashes = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(getAccountCashType, current_user.id, true)
    @categories = Category.order("name ASC").find_all_by_user_id_and_enabled(current_user.id, true)
    @task_new = true
  end

  def edit
    @transaction = Transaction.find(params[:id])
    @task_new = false
  end

  def create
    @transaction = Transaction.new(params[:transaction])
    if(current_user.nil? == false)
      @transaction.user = current_user
      valid = true

      if(@transaction.valid?)
        if (@transaction.transaction_type == getTransactionToAccount ||
            @transaction.transaction_type == getTransactionToCash)
              valid = @transaction.transferSumToAccount
        elsif (@transaction.transaction_type == getTransactionFromAccountToAccount ||
               @transaction.transaction_type == getTransactionFromAccountToCash ||
               @transaction.transaction_type == getTransactionFromCashToAccount ||
               @transaction.transaction_type == getTransactionFromCashToCash)
                  valid = @transaction.transferSumBetweenAccounts
        elsif (@transaction.transaction_type == getTransactionFromAccountToCategory ||
               @transaction.transaction_type == getTransactionFromCashToCategory)
                  valid = @transaction.transferSumFromAccountToCategory
        end
      else
        valid = false
      end
      respond_to do |format|
        if valid == true && @transaction.save
          format.html {redirect_to transactions_path(:type => @transaction.transaction_type, :page => session[:page])}
        else
          @task_new = true
          @accounts = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(getAccountCardType, current_user.id, true)
          @cashes = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(getAccountCashType, current_user.id, true)
          @categories = Category.order("name ASC").find_all_by_user_id_and_enabled(current_user.id, true)

          format.html { render action: "new" }
          format.json { render json: [@transaction.errors, @task_new, @accounts, @cashes, @categories], status: :unprocessable_entity }
        end
      end
    end
  end

  def update
    @transaction = Transaction.find(params[:id])
    p = params[:transaction]
    @transaction.amount = p[:amount]
    valid = true

    if (@transaction.transaction_type == getTransactionToAccount ||
        @transaction.transaction_type == getTransactionToCash)
      valid = @transaction.changeSumToAccount
    elsif (@transaction.transaction_type == getTransactionFromAccountToAccount ||
           @transaction.transaction_type == getTransactionFromAccountToCash ||
           @transaction.transaction_type == getTransactionFromCashToAccount ||
           @transaction.transaction_type == getTransactionFromCashToCash)
      valid = @transaction.changeSumBetweenAccounts
    elsif (@transaction.transaction_type == getTransactionFromAccountToCategory ||
           @transaction.transaction_type == getTransactionFromCashToCategory)
      valid = @transaction.changeSumFromAccountToCategory
    end

    respond_to do |format|
      if valid == true && @transaction.update_attributes(params[:transaction])
        format.html { redirect_to transactions_path(:type => @transaction.transaction_type, :page => session[:page])}
      else
        @task_new = false
        format.html { render action: "edit" }
        format.json { render json: [@transaction.errors, @task_new], status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    valid = true

    if (@transaction.transaction_type == getTransactionToAccount ||
        @transaction.transaction_type == getTransactionToCash)
      valid = @transaction.rollbackSumFromAccount
    elsif (@transaction.transaction_type == getTransactionFromAccountToAccount ||
           @transaction.transaction_type == getTransactionFromAccountToCash ||
           @transaction.transaction_type == getTransactionFromCashToAccount ||
           @transaction.transaction_type == getTransactionFromCashToCash)
      valid = @transaction.rollbackSumBetweenAccounts
    elsif (@transaction.transaction_type == getTransactionFromAccountToCategory ||
           @transaction.transaction_type == getTransactionFromCashToCategory)
      valid = @transaction.rollbackSumFromCategory
    end

    if valid == true
      @transaction.destroy
    end
    respond_to do |format|
      format.html { redirect_to transactions_path(:type => @transaction.transaction_type, :page => session[:page]) }
      format.json { head :no_content } and return
    end
  end
end
