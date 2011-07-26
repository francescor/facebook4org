require 'test_helper'

class PersonalNotificationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:personal_notifications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create personal_notification" do
    assert_difference('PersonalNotification.count') do
      post :create, :personal_notification => { }
    end

    assert_redirected_to personal_notification_path(assigns(:personal_notification))
  end

  test "should show personal_notification" do
    get :show, :id => personal_notifications(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => personal_notifications(:one).to_param
    assert_response :success
  end

  test "should update personal_notification" do
    put :update, :id => personal_notifications(:one).to_param, :personal_notification => { }
    assert_redirected_to personal_notification_path(assigns(:personal_notification))
  end

  test "should destroy personal_notification" do
    assert_difference('PersonalNotification.count', -1) do
      delete :destroy, :id => personal_notifications(:one).to_param
    end

    assert_redirected_to personal_notifications_path
  end
end
