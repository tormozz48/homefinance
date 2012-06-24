require 'test_helper'

class EatingsControllerTest < ActionController::TestCase
  setup do
    @eating = eatings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:eatings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create eating" do
    assert_difference('Eating.count') do
      post :create, eating: @eating.attributes
    end

    assert_redirected_to eating_path(assigns(:eating))
  end

  test "should show eating" do
    get :show, id: @eating
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @eating
    assert_response :success
  end

  test "should update eating" do
    put :update, id: @eating, eating: @eating.attributes
    assert_redirected_to eating_path(assigns(:eating))
  end

  test "should destroy eating" do
    assert_difference('Eating.count', -1) do
      delete :destroy, id: @eating
    end

    assert_redirected_to eatings_path
  end
end
