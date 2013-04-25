class TransactionsController < ApplicationController
  before_filter :authenticate_user!

  MAX_SUM = 10000
  DATE_FROM_DEFAULT = 2.month.ago.to_date

  def index

  end

  def switch
    @transaction_type = params[:type] || Transaction::TR_FROM_CASH_TO_CATEGORY
    render :partial => 'transactions/transactions_table',
           :content_type => 'text/html'
  end

  def show_filter
    load_advanced_data
    @transaction_type = params[:type] || Transaction::TR_FROM_CASH_TO_CATEGORY

    @date_from = session[:date_from] || DATE_FROM_DEFAULT
    @date_to = session[:date_to] || Date.today

    @sum_min = session[:sum_min] || 0
    @sum_max = session[:sum_max] || MAX_SUM

    @account_from = session[:account_from]
    @account_to = session[:account_to]
    @category = session[:category]

    render :partial => 'transactions/filter',
           :content_type => 'text/html'
  end

  def load
      transaction_type = params[:type] || Transaction::TR_FROM_CASH_TO_CATEGORY
      date_from = params[:date_from] || DATE_FROM_DEFAULT
      date_to = params[:date_to] || Date.today

      sum_min = params[:sum_min].to_i || 0
      sum_max = params[:sum_max].to_i || MAX_SUM
      sum_max = sum_max > 0 ? sum_max : MAX_SUM

      field = params[:field] || 'date'
      direction = params[:direction] || 'desc'

      sort_str = "#{field} #{direction}, id DESC"

      @transactions = Transaction.includes(:account_from, :account_to, :category)
            .enabled.by_transaction_type(transaction_type.to_i).by_user(current_user.id)
            .between_dates(date_from, date_to).between_amount(sum_min, sum_max)

      #add account from query
      if params[:account_from].present? || params[:cash_from].present?
         account_from = Account.find(params[:account_from] || params[:cash_from])
         @transactions = @transactions.by_account_from(account_from.id)

         session[:account_from] = account_from.id
      end

      #add account to query
      if params[:account_to].present? || params[:cash_to].present?
         account_to = Account.find(params[:account_to] || params[:cash_to])
         @transactions = @transactions.by_account_to(account_to.id)

         session[:account_to] = account_to.id
      end

      #add categories query
      if params[:category].present?
         category = Category.find(params[:category])
         @transactions = @transactions.by_category(category.id)

         session[:category] = category.id
      end

      @transactions = @transactions.order(sort_str)

      session[:date_from] = date_from
      session[:date_to] = date_to

      session[:sum_min] = sum_min
      session[:sum_max] = sum_max

      render :partial => 'transactions/transactions',
             :content_type => 'text/html'
      #render :json => @transactions, :content_type => 'application/json'
  end

  def new
    @task_new = true
    @transaction = Transaction.new({
               :transaction_type => params[:type],
               :amount => 0,
               :date => Date.today,
               :user_id => current_user.id})
    load_advanced_data

    render :partial => 'transactions/form',
           :content_type => 'text/html'
  end

  def edit
    @task_new = false
    @transaction = Transaction.find(params[:id])
    load_advanced_data

    render :partial => 'transactions/form',
           :content_type => 'text/html'
  end

  def create
    transaction = Transaction.new(params[:transaction])
    valid = transaction.valid? ? transaction.calculate_transaction_new : false

    if valid && transaction.save
      render :nothing => true,
             :status => 200
    else
      render :json => transaction.errors,
             :content_type => 'application/json',
             :status => 206
    end

  end

  def update
    @transaction = Transaction.find(params[:id])
    p = params[:transaction]
    @transaction.amount = p[:amount]
    valid = @transaction.valid? ? @transaction.calculate_transaction_edit : false

    if valid && @transaction.update_attributes(p)
      render :nothing => true,
             :status => 200
    else
      render :json => @transaction.errors,
             :content_type => 'application/json',
             :status => 206
    end

  end

  def destroy
    @transaction = Transaction.find(params[:id])
    valid = @transaction.valid? ? @transaction.calculate_transaction_destroy : false
    if valid && @transaction.destroy
      render :nothing => true,
             :status => 200
    else
      render :nothing => true,
             :status => 206
    end
  end
end

def load_advanced_data
  @accounts = Account.order_by_name.accounts.enabled.by_user(current_user.id)
  @cashes = Account.order_by_name.cashes.enabled.by_user(current_user.id)
  @categories = Category.order_by_name.enabled.by_user(current_user.id)
end
