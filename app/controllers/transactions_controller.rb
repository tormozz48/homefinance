class TransactionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @transaction_type = params[:type]
    if @transaction_type.nil?
      @transaction_type = Transaction::TRANSACTION_FROM_CASH_TO_CATEGORY
    else
      @transaction_type = @transaction_type.to_i
    end
    if Transaction::TRANSACTION_TYPES.include? @transaction_type
      @categories = Category.where("enabled = true and user_id = ?", current_user.id).order("name asc")
      @date_from = 1.week.ago.to_date
      @date_to = Date.today
    else
      render_404
    end
  end

  def load

  end

  def filter
      transaction_type = params[:type]
      date_from = params[:date_from].nil? ? 1.week.ago.to_date : params[:date_from]
      date_to = params[:date_to].nil? ? Date.today : params[:date_to]
      category_id = params[:category]

      field = params[:field].nil? ? "date" : params[:field]
      direction = params[:direction].nil? ? "desc" : params[:direction]
      sortStr = field + " " + direction + ", id DESC"

      if !category_id.nil? && !category_id.blank? &&
          (transaction_type == Transaction::TRANSACTION_FROM_ACCOUNT_TO_CATEGORY.to_s(10) ||
              transaction_type == Transaction::TRANSACTION_FROM_CASH_TO_CATEGORY.to_s(10))
        @transactions = Transaction.where("transaction_type = :transaction_type and
                                           user_id = :user_id and
                                           enabled = :enabled and
                                           category_id = :category_id and
                                           date between :date_from and :date_to",
                                          {:transaction_type => transaction_type,
                                           :user_id => current_user.id,
                                           :enabled => true,
                                           :category_id => category_id,
                                           :date_from => date_from,
                                           :date_to => date_to
                                          }).order(sortStr)
      else
        @transactions = Transaction.where("transaction_type = :transaction_type and
                                           user_id = :user_id and
                                           enabled = :enabled and
                                           date between :date_from and :date_to",
                                          {:transaction_type => transaction_type,
                                           :user_id => current_user.id,
                                           :enabled => true,
                                           :date_from => date_from,
                                           :date_to => date_to
                                          }).order(sortStr)
      end
      render :partial => 'transactions/transactions'
  end

  def new
    @transaction = Transaction.new(:transaction_type => params[:type], :amount => 0, :date => Date.today)
    @accounts = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(Account::ACCOUNT_CARD_TYPE, current_user.id, true)
    @cashes = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(Account::ACCOUNT_CASH_TYPE, current_user.id, true)
    @categories = Category.order("name ASC").find_all_by_user_id_and_enabled(current_user.id, true)
    @task_new = true
  end

  def edit
    @transaction = Transaction.find(params[:id])
    @accounts = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(Account::ACCOUNT_CARD_TYPE, current_user.id, true)
    @cashes = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(Account::ACCOUNT_CASH_TYPE, current_user.id, true)
    @categories = Category.order("name ASC").find_all_by_user_id_and_enabled(current_user.id, true)
    @task_new = false
    if @transaction.nil?
      render_404
    end
  end

  def create
    @transaction = Transaction.new(params[:transaction])
    if(current_user.nil? == false)
      @transaction.user = current_user
      valid = @transaction.valid? ? @transaction.calculateTransactionNew : false
      respond_to do |format|
        if valid == true && @transaction.save
          format.html {redirect_to transactions_path(:type => @transaction.transaction_type, :page => session[:page])}
        else
          @task_new = true
          @accounts = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(Account::ACCOUNT_CARD_TYPE, current_user.id, true)
          @cashes = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(Account::ACCOUNT_CASH_TYPE, current_user.id, true)
          @categories = Category.order("name ASC").find_all_by_user_id_and_enabled(current_user.id, true)

          format.html { render action: "new" }
          format.json { render json: [@transaction.errors, @task_new, @accounts, @cashes, @categories], status: :unprocessable_entity }
        end
      end
    end
  end

  def update
    @transaction = Transaction.find(params[:id])
    if @transaction.nil?
      render_404
    end
    p = params[:transaction]
    @transaction.amount = p[:amount]
    valid = @transaction.valid? ? @transaction.calculateTransactionEdit : false
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
    if @transaction.nil?
      render_404
    end
    valid = @transaction.valid? ? @transaction.calculateTransactionDestroy : false
    @transaction.destroy if valid
    respond_to do |format|
      format.html { redirect_to transactions_path(:type => @transaction.transaction_type, :page => session[:page]) }
    end
  end
end
