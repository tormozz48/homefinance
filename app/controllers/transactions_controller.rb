class TransactionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @transaction_type = params[:type]
    if @transaction_type.nil?
      @transaction_type = session["transaction_type"]
      if @transaction_type.nil?
        @transaction_type = Transaction::TRANSACTION_FROM_CASH_TO_CATEGORY
      else
        @transaction_type = @transaction_type.to_i
      end
    else
      @transaction_type = @transaction_type.to_i
    end
    if Transaction::TRANSACTION_TYPES.include? @transaction_type
      @categories = Category.where("enabled = true and user_id = ?", current_user.id).order("name asc")
      #@date_from = session["date_from"].nil? ? 1.week.ago.to_date : session["date_from"]
      #@date_to = session["date_to"].nil? ? Date.today : session["date_to"]
      @date_from = 1.week.ago.to_date
      @date_to = Date.today
      @field = session["field"]
      #@direction = session["direction"]
      @direction = "desc"
      @category_id = session["category_id"]
    else
      render_404
    end
  end

  def filter
      transaction_type = params[:type]
      date_from = params[:date_from].nil? ? 1.week.ago.to_date : params[:date_from]
      date_to = params[:date_to].nil? ? Date.today : params[:date_to]
      category_id = params[:category]

      session["transaction_type"] = transaction_type
      session["date_from"] = date_from
      session["date_to"] = date_to
      session["category_id"] = category_id

      field = params[:field].nil? ? "date" : params[:field]
      direction = params[:direction].nil? ? "desc" : params[:direction]

      session["field"] = field
      session["direction"] = direction

      sortStr = field + " " + direction + ", id DESC"

      if !category_id.nil? && !category_id.blank? &&
          (transaction_type == Transaction::TRANSACTION_FROM_ACCOUNT_TO_CATEGORY.to_s(10) ||
              transaction_type == Transaction::TRANSACTION_FROM_CASH_TO_CATEGORY.to_s(10))
        @transactions = Transaction.where("transaction_type = :transaction_type and user_id = :user_id and
          enabled = :enabled and category_id = :category_id and date between :date_from and :date_to",
          {:transaction_type => transaction_type, :user_id => current_user.id, :enabled => true,
           :category_id => category_id, :date_from => date_from, :date_to => date_to
          }).order(sortStr)
      else
        @transactions = Transaction.where("transaction_type = :transaction_type and user_id = :user_id and
          enabled = :enabled and date between :date_from and :date_to",
          {:transaction_type => transaction_type, :user_id => current_user.id, :enabled => true,
           :date_from => date_from, :date_to => date_to
          }).order(sortStr)
      end
      render :partial => 'transactions/transactions'
  end

  def new
    @transaction = Transaction.new(:transaction_type => params[:type], :amount => 0, :date => Date.today)
    getParamsForSelectors
    @task_new = true
  end

  def edit
    @transaction = Transaction.find(params[:id])
    if @transaction.nil?
      render_404 and return
    end
    getParamsForSelectors
    @task_new = false
  end

  def create
    @transaction = Transaction.new(params[:transaction])
    @transaction.user = current_user
    valid = @transaction.valid? ? @transaction.calculateTransactionNew : false
    respond_to do |format|
      if valid == true && @transaction.save
        flash[:notice] = I18n.t('notice.transaction.added')
        format.html {redirect_to transactions_path}
      else
        getParamsForSelectors
        @task_new = true
        format.html { render :action => "new"}
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
        flash[:notice] = I18n.t('notice.transaction.changed')
        format.html {redirect_to transactions_path}
      else
        getParamsForSelectors
        @task_new = false
        format.html { render :action => "edit"}
      end
    end
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    if @transaction.nil?
      render_404
    end
    valid = @transaction.valid? ? @transaction.calculateTransactionDestroy : false
    if valid
      @transaction.destroy
      flash[:notice] = I18n.t('notice.transaction.deleted')
    else
      flash[:error] = I18n.t('error.transaction.deleted')
    end
    redirect_to transactions_path
  end
end

def getParamsForSelectors
  @accounts = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(Account::ACCOUNT_CARD_TYPE, current_user.id, true)
  @cashes = Account.order("name ASC").find_all_by_account_type_and_user_id_and_enabled(Account::ACCOUNT_CASH_TYPE, current_user.id, true)
  @categories = Category.order("name ASC").find_all_by_user_id_and_enabled(current_user.id, true)
end
