require 'spec_helper'

describe AccountsController do

  before(:each) do
    @user = FactoryGirl.create(:user1)
  end

  it 'should go to index (card) action' do
    sign_in @user

    get :index, {:type => 0}
    assigns(:account_type).present?.should be_true
    assert_template 'index'
    response.should be_success
  end

  it 'should go to index (cash) action' do
    sign_in @user

    get :index, {:type => 1}
    assigns(:account_type).present?.should be_true
    assert_template 'index'
    response.should be_success
  end

  it 'should go to index (unknown) action' do
    sign_in @user

    get :index, {:type => -1}
  end

  it 'should go to sort action with params' do
    sign_in @user

    FactoryGirl.create(:account1)
    FactoryGirl.create(:account2)
    FactoryGirl.create(:account3)
    FactoryGirl.create(:account4)

    get :load, {:type => 0, :field => 'amount', :direction => 'desc'}
    assigns(:accounts).present?.should be_true
    assert_template :partial => '_accounts'
    response.should be_success
  end

  it 'should go to load action with default params' do
    sign_in @user

    FactoryGirl.create(:account1)
    FactoryGirl.create(:account2)
    FactoryGirl.create(:account3)
    FactoryGirl.create(:account4)

    get :load, {:type => 0}
    assigns(:accounts).present?.should be_true
    assert_template :partial => '_accounts'
    response.should be_success
  end

  it 'should go to new (card) action' do
    sign_in @user

    get :new,  {:type => 0}
    assigns(:account).present?.should be_true
    assert_template 'new'
    response.should be_success
  end

  it 'should go to new (cash) action' do
    sign_in @user

    get :new,  {:type => 0}
    assigns(:account).present?.should be_true
    assert_template 'new'
    response.should be_success
  end

  it 'should go to edit action' do
    sign_in @user

    FactoryGirl.create(:account1)
    get :edit,  {:id => 1}
    assigns(:account).present?.should be_true
    assert_template 'edit'
    response.should be_success
  end

  it 'should go to create action' do
    sign_in @user

    post :create, {account: {
        user_id: 1,
        account_type: 0,
        amount: 0,
        enabled: true,
        name: 'test account name',
        description: 'test account description'
    }}

    Account.all.size.should eq(1)

    assigns(:account).present?.should be_true
    assigns(:account_type).present?.should be_true

    redirect_to(accounts_path(:type => 0))
  end

  it 'should go to create action with error' do
    sign_in @user

    post :create, {account: {
        user_id: 1,
        account_type: 0,
        amount: 0,
        enabled: true,
        name: nil,
        description: nil
    }}

    Account.all.size.should eq(0)

    assigns(:account).present?.should be_true
    assigns(:account_type).present?.should be_true

    assert_template 'new'
    response.should be_success
  end

  it 'should go to update action' do
    sign_in @user

    account = FactoryGirl.create(:account1)

    db_account = Account.find(1)
    db_account.name.should eq(account.name)
    db_account.description.should eq(account.description)

    put :update, {id: account.id, account: {
        user_id: 1,
        account_type: 0,
        amount: 0,
        enabled: true,
        name: 'test account name',
        description: 'test account description'
    }}

    db_account_updated = Account.find(1)
    db_account_updated.name.should eq('test account name')
    db_account_updated.description.should eq('test account description')

    redirect_to(accounts_path(:type => 0))
  end

  it 'should go to update action with error' do
    sign_in @user

    account = FactoryGirl.create(:account1)

    db_account = Account.find(1)
    db_account.name.should eq(account.name)
    db_account.description.should eq(account.description)

    put :update, {id: account.id, account: {
        user_id: 1,
        account_type: 0,
        amount: 0,
        enabled: true,
        name: nil,
        description: nil
    }}

    db_account_updated = Account.find(1)
    db_account_updated.name.should eq(account.name)
    db_account_updated.description.should eq(account.description)

    assigns(:account).present?.should be_true
    assigns(:account_type).present?.should be_true

    assert_template 'edit'
    response.should be_success
  end

  it 'should go to destroy action' do
    sign_in @user

    FactoryGirl.create(:account1)
    delete :destroy, {id: 1}
    Account.find(1).enabled.should eq(false)

    response.should be_success
  end
end
