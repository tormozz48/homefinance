class TransactionsController < ApplicationController
  before_filter :authenticate_user!

  def index

  end

  def switch
    @transaction_type = params[:type] || Transaction::TR_FROM_CASH_TO_CATEGORY
    render :partial => 'transactions/transactions_table'
  end

  def load
      transaction_type = params[:type] || Transaction::TR_FROM_CASH_TO_CATEGORY
      date_from = params[:date_from] || 1.year.ago.to_date
      date_to = params[:date_to] || Date.today

      summa_min = params[:summa_min] || 0
      summa_max = params[:summa_max] || 999999

      category_id = params[:category]

      field = params[:field] || 'date'
      direction = params[:direction] || 'desc'

      sort_str = "#{field} #{direction}, id DESC"

      @transactions = Transaction.includes(:account_from, :account_to, :category)
            .enabled.by_transaction_type(transaction_type).by_user(current_user.id)
            .between_dates(date_from, date_to).between_amount(summa_min, summa_max)

      if !(category_id.nil? || category_id.blank?) &&
          transaction_type.to_i.in?(Transaction::TR_GROUP_TO_CATEGORY)
        @transactions = @transactions.by_category(category_id)
      end

      @transactions = @transactions.order(sort_str)

      render :partial => 'transactions/transactions'
  end

  def new
    @task_new = true
    @transaction = Transaction.new({
               :transaction_type => params[:type],
               :amount => 0,
               :date => Date.today,
               :user_id => current_user.id})
    load_advanced_data

    render :partial => 'transactions/form'
  end

  def edit
    @task_new = false
    @transaction = Transaction.find(params[:id])
    load_advanced_data

    render :partial => 'transactions/form'
  end

  def create
    @transaction = Transaction.new(params[:transaction])
    valid = @transaction.valid? ? @transaction.calculate_transaction_new : false
    respond_to do |format|
      if valid && @transaction.save
        flash[:notice] = I18n.t('notice.transaction.added')
        format.html {redirect_to transactions_path}
      else
        @task_new = true
        load_advanced_data
        format.html { render :action => 'new'}
      end
    end
  end

  def update
    @transaction = Transaction.find(params[:id])
    p = params[:transaction]
    @transaction.amount = p[:amount]
    valid = @transaction.valid? ? @transaction.calculate_transaction_edit : false
    respond_to do |format|
      if valid && @transaction.update_attributes(p)
        flash[:notice] = I18n.t('notice.transaction.changed')
        format.html {redirect_to transactions_path}
      else
        @task_new = false
        load_advanced_data
        format.html { render :action => 'edit'}
      end
    end
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    valid = @transaction.valid? ? @transaction.calculate_transaction_destroy : false
    if valid && @transaction.destroy
      render :json => {:message => I18n.t('notice.transaction.deleted'), :type => 'success'}
    else
      render :json => {:message => I18n.t('error.transaction.deleted'), :type => 'error'}
    end
  end
end

def load_advanced_data
  @accounts = Account.order_by_name.accounts.enabled.by_user(current_user.id)
  @cashes = Account.order_by_name.cashes.enabled.by_user(current_user.id)
  @categories = Category.order_by_name.enabled.by_user(current_user.id)
end
