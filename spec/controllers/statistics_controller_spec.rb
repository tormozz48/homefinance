require 'spec_helper'

describe StatisticsController do
  before(:each) do
    @user = FactoryGirl.create(:user1)

    FactoryGirl.create(:category1)
    FactoryGirl.create(:transaction1)
    FactoryGirl.create(:transaction1)
    FactoryGirl.create(:transaction1)
    FactoryGirl.create(:transaction1)
    FactoryGirl.create(:transaction1)
    FactoryGirl.create(:transaction1)
    FactoryGirl.create(:transaction1)
    FactoryGirl.create(:transaction1)
  end
end