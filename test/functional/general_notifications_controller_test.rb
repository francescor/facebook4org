require 'test_helper'

class GeneralNotificationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:general_notifications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create general_notification" do
    assert_difference('GeneralNotification.count') do
      post :create, :general_notification => { }
    end

    assert_redirected_to general_notification_path(assigns(:general_notification))
  end

  test "should show general_notification" do
    get :show, :id => general_notifications(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => general_notifications(:one).to_param
    assert_response :success
  end

  test "should update general_notification" do
    put :update, :id => general_notifications(:one).to_param, :general_notification => { }
    assert_redirected_to general_notification_path(assigns(:general_notification))
  end

  test "should destroy general_notification" do
    assert_difference('GeneralNotification.count', -1) do
      delete :destroy, :id => general_notifications(:one).to_param
    end

    assert_redirected_to general_notifications_path
  end
end
