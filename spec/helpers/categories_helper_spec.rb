require 'spec_helper'

describe CategoriesHelper do
  before(:each) do
    @category = FactoryGirl.create(:category1)
  end

  it 'should return color' do
    get_color(@category).should eq('#000000')
  end

  it 'should return white color for nil' do
    @category.color = nil
    get_color(@category).should eq('#fff')
  end
end