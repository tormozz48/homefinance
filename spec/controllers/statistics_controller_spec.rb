require 'spec_helper'

describe StatisticsController do
  before(:each) do
    @user = FactoryGirl.create(:user1)
  end

  it 'should go to index action' do
    sign_in @user

    get :index

    assigns(:date_from).present?.should be_true
    assigns(:date_to).present?.should be_true

    assert_template :index
    response.should be_success
  end

  it 'should go to load by date action 1' do
    FactoryGirl.create(:transaction1)

    sign_in @user

    get :load_by_date,  {:type => Transaction::TR_TO_ACCOUNT,
                         :date_from => 2.week.ago.to_date.to_s(:db),
                         :date_to => Date.today.to_s(:db)}

    assigns(:transactions).present?.should be_true
    response.should be_success
  end

  it 'should go to load by date action 2' do
    FactoryGirl.create(:transaction2)

    sign_in @user

    get :load_by_date,  {:type => Transaction::TR_FROM_ACCOUNT_TO_ACCOUNT,
                         :date_from => 2.week.ago.to_date.to_s(:db),
                         :date_to => Date.today.to_s(:db)}

    assigns(:transactions).present?.should be_true
    response.should be_success
  end

  it 'should go to load by date action 3' do
    FactoryGirl.create(:transaction3)

    sign_in @user

    get :load_by_date,  {:type => Transaction::TR_FROM_ACCOUNT_TO_CASH,
                         :date_from => 2.week.ago.to_date.to_s(:db),
                         :date_to => Date.today.to_s(:db)}

    assigns(:transactions).present?.should be_true
    response.should be_success
  end

  it 'should go to load by date action 4' do
    FactoryGirl.create(:transaction4)

    sign_in @user

    get :load_by_date,  {:type => Transaction::TR_FROM_ACCOUNT_TO_CATEGORY,
                         :date_from => 2.week.ago.to_date.to_s(:db),
                         :date_to => Date.today.to_s(:db)}

    assigns(:transactions).present?.should be_true
    response.should be_success
  end

  it 'should go to load by date action 5' do
    FactoryGirl.create(:transaction5)

    sign_in @user

    get :load_by_date,  {:type => Transaction::TR_TO_CASH,
                         :date_from => 2.week.ago.to_date.to_s(:db),
                         :date_to => Date.today.to_s(:db)}

    assigns(:transactions).present?.should be_true
    response.should be_success
  end

  it 'should go to load by date action 6' do
    FactoryGirl.create(:transaction6)

    sign_in @user

    get :load_by_date,  {:type => Transaction::TR_FROM_CASH_TO_ACCOUNT,
                         :date_from => 2.week.ago.to_date.to_s(:db),
                         :date_to => Date.today.to_s(:db)}

    assigns(:transactions).present?.should be_true
    response.should be_success
  end

  it 'should go to load by date action 7' do
    FactoryGirl.create(:transaction7)

    sign_in @user

    get :load_by_date,  {:type => Transaction::TR_FROM_CASH_TO_CASH,
                         :date_from => 2.week.ago.to_date.to_s(:db),
                         :date_to => Date.today.to_s(:db)}

    assigns(:transactions).present?.should be_true
    response.should be_success
  end

  it 'should go to load by date action 8' do
    FactoryGirl.create(:transaction8)

    sign_in @user

    get :load_by_date,  {:type => Transaction::TR_FROM_CASH_TO_CATEGORY,
                         :date_from => 2.week.ago.to_date.to_s(:db),
                         :date_to => Date.today.to_s(:db)}

    assigns(:transactions).present?.should be_true
    response.should be_success
  end

  it 'should go to load by category action' do
    FactoryGirl.create(:category1)
    FactoryGirl.create(:transaction8)

    sign_in @user

    get :load_by_category,  {:date_from => 2.week.ago.to_date.to_s(:db),
                             :date_to => Date.today.to_s(:db)}

    assigns(:transactions).present?.should be_true
    response.should be_success
  end
end