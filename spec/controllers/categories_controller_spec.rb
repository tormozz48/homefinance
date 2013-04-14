require 'spec_helper'

describe CategoriesController do

  before(:each) do
    @user = FactoryGirl.create(:user1)
  end

  it 'should go to index action' do
    sign_in @user

    get :index
    assert_template 'index'
    response.should be_success
  end

  it 'should go to load action with params' do
    sign_in @user

    FactoryGirl.create(:category1)

    get :load, {:field => 'description', :direction => 'desc'}
    assigns(:categories).present?.should be_true
    assert_template :partial => '_categories'
    response.should be_success
  end

  it 'should go to load action with default params' do
    sign_in @user

    FactoryGirl.create(:category1)

    get :load
    assigns(:categories).present?.should be_true
    assert_template :partial => '_categories'
    response.should be_success
  end

  it 'should go to new action' do
    sign_in @user

    get :new
    assigns(:category).present?.should be_true
    assert_template 'new'
    response.should be_success
  end

  it 'should go to edit action' do
    sign_in @user

    FactoryGirl.create(:category1)
    get :edit,  {:id => 1}
    assigns(:category).present?.should be_true
    assert_template 'edit'
    response.should be_success
  end

  it 'should go to create action' do
    sign_in @user

    post :create, {category: {
        user_id: 1,
        amount: 0,
        enabled: true,
        name: 'test category name',
        description: 'test category description',
        color: 'ffffff'
    }}

    Category.all.size.should eq(1)
    assigns(:category).present?.should be_true
    redirect_to(categories_path)
  end

  it 'should go to create action with error' do
    sign_in @user

    post :create, {category: {
        user_id: 1,
        color: nil,
        amount: 0,
        enabled: true,
        name: nil,
        description: nil
    }}

    Category.all.size.should eq(0)
    assigns(:category).present?.should be_true
    assert_template 'new'
    response.should be_success
  end

  it 'should go to update action' do
    sign_in @user

    category = FactoryGirl.create(:category1)

    db_category = Category.find(1)
    db_category.name.should eq(category.name)
    db_category.description.should eq(category.description)
    db_category.color.should eq(category.color)

    put :update, {id: category.id, category: {
        user_id: 1,
        amount: 0,
        enabled: true,
        name: 'test category name',
        description: 'test category description',
        color: 'ffffff'
    }}

    db_category_updated = Category.find(1)
    db_category_updated.name.should eq('test category name')
    db_category_updated.description.should eq('test category description')
    db_category_updated.color.should eq('ffffff')


    redirect_to(accounts_path)
  end

  it 'should go to update action with error' do
    sign_in @user

    category = FactoryGirl.create(:category1)

    db_category = Category.find(1)
    db_category.name.should eq(category.name)
    db_category.description.should eq(category.description)
    db_category.color.should eq(category.color)

    put :update, {id: category.id, category: {
        user_id: 1,
        amount: 0,
        enabled: true,
        name: nil,
        description: nil,
        color: nil
    }}

    db_category_updated = Category.find(1)
    db_category_updated.name.should eq(category.name)
    db_category_updated.description.should eq(category.description)
    db_category_updated.color.should eq(category.color)

    assigns(:category).present?.should be_true

    assert_template 'edit'
    response.should be_success
  end

  it 'should go to destroy action' do
    sign_in @user

    FactoryGirl.create(:category1)
    delete :destroy, {id: 1}
    Category.find(1).enabled.should eq(false)

    response.should be_success
  end
end