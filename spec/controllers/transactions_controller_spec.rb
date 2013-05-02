require 'spec_helper'

describe TransactionsController do

  before(:each) do
    @user = FactoryGirl.create(:user1)
  end

  it 'should go to index action' do
    sign_in @user

    get :index
    response.should be_success
  end

  it 'should go to switch action' do
    sign_in @user

    get :switch,  {:type => 1}
    assert_template :partial => '_transactions_table'
    response.should be_success
  end

  it 'should go to show filter action' do
    sign_in @user

    get :show_filter,  {:type => 1}

    assigns(:transaction_type).present?.should be_true
    assigns(:date_from).present?.should be_true
    assigns(:date_to).present?.should be_true
    assigns(:sum_min).present?.should be_true
    assigns(:sum_max).present?.should be_true

    assert_template :partial => '_filter'
    response.should be_success
  end

  it 'should go to load action 1' do
    FactoryGirl.create(:account1)
    FactoryGirl.create(:transaction1)

    sign_in @user

    get :load,  {:type => 0, :account_to => 1}

    assigns(:transactions).present?.should be_true

    assert_template :partial => '_transactions'
    response.should be_success
  end

  it 'should go to load action 2' do
    FactoryGirl.create(:account1)
    FactoryGirl.create(:account3)
    FactoryGirl.create(:transaction2)

    sign_in @user

    get :load,  {:type => 1, :account_from => 1, :account_to => 3}

    assigns(:transactions).present?.should be_true

    assert_template :partial => '_transactions'
    response.should be_success
  end

  it 'should go to load action 3' do
    FactoryGirl.create(:account1)
    FactoryGirl.create(:account2)
    FactoryGirl.create(:transaction3)

    sign_in @user

    get :load,  {:type => 2, :account_from => 1, :account_to => 2}

    assigns(:transactions).present?.should be_true

    assert_template :partial => '_transactions'
    response.should be_success
  end

  it 'should go to load action 4' do
    FactoryGirl.create(:account1)
    FactoryGirl.create(:category1)
    FactoryGirl.create(:transaction4)

    sign_in @user

    get :load,  {:type => 3, :account_from => 1, :category => 1}

    assigns(:transactions).present?.should be_true

    assert_template :partial => '_transactions'
    response.should be_success
  end

  it 'should go to load action 5' do
    FactoryGirl.create(:account2)
    FactoryGirl.create(:transaction5)

    sign_in @user

    get :load,  {:type => 4, :account_to => 2}

    assigns(:transactions).present?.should be_true

    assert_template :partial => '_transactions'
    response.should be_success
  end

  it 'should go to load action 6' do
    FactoryGirl.create(:account1)
    FactoryGirl.create(:account2)
    FactoryGirl.create(:transaction6)

    sign_in @user

    get :load,  {:type => 5, :account_from => 2, :account_to => 1}

    assigns(:transactions).present?.should be_true

    assert_template :partial => '_transactions'
    response.should be_success
  end

  it 'should go to load action 7' do
    FactoryGirl.create(:account2)
    FactoryGirl.create(:account4)
    FactoryGirl.create(:transaction7)

    sign_in @user

    get :load,  {:type => 6, :account_from => 2, :account_to => 4}

    assigns(:transactions).present?.should be_true

    assert_template :partial => '_transactions'
    response.should be_success
  end

  it 'should go to load action 7' do
    FactoryGirl.create(:account2)
    FactoryGirl.create(:category1)
    FactoryGirl.create(:transaction8)

    sign_in @user

    get :load,  {:type => 7, :account_from => 2, :category => 1}

    assigns(:transactions).present?.should be_true

    assert_template :partial => '_transactions'
    response.should be_success
  end

  it 'should go to new action' do
    FactoryGirl.create(:account1)
    FactoryGirl.create(:account2)
    FactoryGirl.create(:category1)

    sign_in @user

    get :new

    assigns(:transaction).present?.should be_true
    assigns(:task_new).should eq(true)
    assigns(:accounts).present?.should be_true
    assigns(:cashes).present?.should be_true
    assigns(:categories).present?.should be_true

    assert_template :partial => '_form'
    response.should be_success
  end

  it 'should go to edit action' do
    FactoryGirl.create(:account1)
    FactoryGirl.create(:account2)
    FactoryGirl.create(:category1)
    FactoryGirl.create(:transaction1)
    sign_in @user

    get :edit,  {:id => 1}

    assigns(:transaction).present?.should be_true
    assigns(:task_new).should eq(false)
    assigns(:accounts).present?.should be_true
    assigns(:cashes).present?.should be_true
    assigns(:categories).present?.should be_true

    assert_template :partial => '_form'
    response.should be_success
  end

  it 'should go to create action' do
    sign_in @user

    FactoryGirl.create(:account1)

    post :create, {transaction: {
        user_id: 1,
        account_from_id: nil,
        account_to_id: 1,
        category_id: nil,
        amount: 10,
        date: '2013-03-09',
        transaction_type: 0,
        comment: 'transaction to account comment',
        enabled: true
    }}

    Transaction.all.size.should eq(1)
    response.should be_success
  end

  it 'should go to create action with error' do
    sign_in @user

    FactoryGirl.create(:account1)

    post :create, {transaction: {
        user_id: nil,
        account_from_id: nil,
        account_to_id: 1,
        category_id: nil,
        amount: -1,
        date: nil,
        transaction_type: 0,
        comment: 'transaction to account comment',
        enabled: true
    }}

    Transaction.all.size.should eq(0)
    response.status.should eq(206)
  end

  it 'should go to update action' do
    FactoryGirl.create(:account1)
    transaction = FactoryGirl.create(:transaction1)

    sign_in @user

    db_transaction = Transaction.find(1)
    db_transaction.user_id.should eq(transaction.user_id)
    db_transaction.account_to_id.should eq(transaction.account_to_id)
    db_transaction.amount.should eq(transaction.amount)
    db_transaction.date.should eq(transaction.date)
    db_transaction.transaction_type.should eq(transaction.transaction_type)
    db_transaction.comment.should eq(transaction.comment)
    db_transaction.enabled.should eq(transaction.enabled)

    put :update, {id: transaction.id, transaction: {
        user_id: 1,
        account_from_id: nil,
        account_to_id: 1,
        category_id: nil,
        amount: 200,
        date: '2013-04-11',
        transaction_type: 0,
        comment: 'transaction to account comment new',
        enabled: true
    }}

    db_transaction_updated = Transaction.find(1)
    db_transaction_updated.amount.should eq(200)
    db_transaction_updated.date.to_s(:db).should eq('2013-04-11')
    db_transaction_updated.comment.should eq('transaction to account comment new')

  end

  it 'should go to update action with error' do
    FactoryGirl.create(:account1)
    transaction = FactoryGirl.create(:transaction1)

    sign_in @user

    db_transaction = Transaction.find(1)
    db_transaction.user_id.should eq(transaction.user_id)
    db_transaction.account_to_id.should eq(transaction.account_to_id)
    db_transaction.amount.should eq(transaction.amount)
    db_transaction.date.should eq(transaction.date)
    db_transaction.transaction_type.should eq(transaction.transaction_type)
    db_transaction.comment.should eq(transaction.comment)
    db_transaction.enabled.should eq(transaction.enabled)

    put :update, {id: transaction.id, transaction: {
        user_id: 1,
        account_from_id: nil,
        account_to_id: 1,
        category_id: nil,
        amount: -1,
        date: nil,
        transaction_type: 0,
        comment: 'transaction to account comment new',
        enabled: true
    }}

    db_transaction_updated = Transaction.find(1)
    db_transaction_updated.amount.should eq(transaction.amount)
    db_transaction_updated.date.should eq(transaction.date)
    db_transaction_updated.comment.should eq(transaction.comment)

    response.status.should eq(206)
  end

  it 'should go to destroy action' do
    FactoryGirl.create(:account2)
    FactoryGirl.create(:category1)
    FactoryGirl.create(:transaction8)

    sign_in @user

    delete :destroy, {id: 8}

    Transaction.all.size.should eq(0)

    response.status.should eq(200)
  end

  it 'should go to destroy action with error' do
    FactoryGirl.create(:account1)
    FactoryGirl.create(:transaction1)

    sign_in @user

    delete :destroy, {id: 1}

    Transaction.all.size.should eq(1)

    response.status.should eq(206)
  end

end