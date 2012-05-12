require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  fixtures :categories

  def setup
    @category = Category.new(
      :name => "Test category 1",
      :description => "Test category 1 description",
      :color => "ff0000",
      :amount => 100
    )
  end

  test "presence name" do
    @category.name = nil
    assert !@category.valid?
    assert_not_nil @category.errors
  end

  test "presence color" do
    @category.color = nil
    assert !@category.valid?
    assert_not_nil @category.errors
  end

  test "presence amount" do
    @category.amount = nil
    assert !@category.valid?
    assert_not_nil @category.errors
  end

  test "amount is numerical" do
      @category.amount = "abc"
      assert !@category.valid?
    assert_not_nil @category.errors
  end

  test "amount is negative" do
    @category.amount = -1
    assert !@category.valid?
    assert_not_nil @category.errors
  end

  test "name length min" do
    @category.name = "abcd"
    assert !@category.valid?
    assert_not_nil @category.errors
  end

  test "name length max" do
    @category.name = "abcdefghijklmnopqrstuvwxyz12345"
    assert !@category.valid?
    assert_not_nil @category.errors
  end

  test "description length max" do
    @category.description = "abcdefghijklmnopqrstuvwxyz1234 abcdefghijklmnopqrstuvwxyz1234 abcdefghijklmnopqrstuvwxyz1234
                             abcdefghijklmnopqrstuvwxyz1234 abcdefghijklmnopqrstuvwxyz1234 abcdefghijklmnopqrstuvwxyz1234
                             abcdefghijklmnopqrstuvwxyz1234 abcdefghijklmnopqrstuvwxyz1234 abcdefghijklmnopqrstuvwxyz1234"
    assert !@category.valid?
    assert_not_nil @category.errors
  end

  test "color length equal" do
    @category.color="12345"
    assert !@category.valid?
    assert_not_nil @category.errors
  end

end
