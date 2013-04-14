require 'spec_helper'

describe ApplicationController do

  it 'should go to about action' do
    get :about

    assert_template 'application/about'
    response.should be_success
  end

  it 'should go to contacts action' do
    get :contacts

    assert_template 'application/contacts'
    response.should be_success
  end
end