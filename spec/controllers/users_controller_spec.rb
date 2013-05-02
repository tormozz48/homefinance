require 'spec_helper'

describe UsersController do

  before(:each) do
    @user = FactoryGirl.create(:user1)
  end


  it 'should go to edit action' do
    sign_in @user

    get :edit

    assigns(:user).present?.should be_true
    assert_template 'devise/user_profile'
    response.should be_success
  end

  it 'should go to update action' do
    sign_in @user

    put :update, {id: @user.id, user: {
        #email: 'testemail@gmail.com',
        first_name: 'test_first_name',
        last_name: 'test_last_name'
    }}

    u = User.find(@user.id)
    #u.email.should eq('testemail@gmail.com')
    u.first_name.should eq('test_first_name')
    u.last_name.should eq('test_last_name')

    redirect_to(root_path)
  end

  it 'should go to update action with errors' do
    sign_in @user

    put :update, {id: @user.id, user: {
        email: nil,
        first_name: nil,
        last_name: nil
    }}

    assert_template 'devise/user_profile'
    response.should be_success
  end
end