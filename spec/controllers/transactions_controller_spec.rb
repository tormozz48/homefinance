require 'spec_helper'

describe TransactionsController do

  before(:each) do
    @user = FactoryGirl.create(:user1)
  end

  it 'should go to index action' do
    sign_in @user

    get :index,  {:type => 1}

    assigns(:transaction_type).present?.should be_true
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
end