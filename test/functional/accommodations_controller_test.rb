require 'test_helper'

class AccommodationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accommodations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create accommodation" do
    assert_difference('Accommodation.count') do
      post :create, :accommodation => { }
    end

    assert_redirected_to accommodation_path(assigns(:accommodation))
  end

  test "should show accommodation" do
    get :show, :id => accommodations(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => accommodations(:one).to_param
    assert_response :success
  end

  test "should update accommodation" do
    put :update, :id => accommodations(:one).to_param, :accommodation => { }
    assert_redirected_to accommodation_path(assigns(:accommodation))
  end

  test "should destroy accommodation" do
    assert_difference('Accommodation.count', -1) do
      delete :destroy, :id => accommodations(:one).to_param
    end

    assert_redirected_to accommodations_path
  end
end
