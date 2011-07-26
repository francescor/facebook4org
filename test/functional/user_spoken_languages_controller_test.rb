require 'test_helper'

class UserSpokenLanguagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_spoken_languages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_spoken_language" do
    assert_difference('UserSpokenLanguage.count') do
      post :create, :user_spoken_language => { }
    end

    assert_redirected_to user_spoken_language_path(assigns(:user_spoken_language))
  end

  test "should show user_spoken_language" do
    get :show, :id => user_spoken_languages(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => user_spoken_languages(:one).to_param
    assert_response :success
  end

  test "should update user_spoken_language" do
    put :update, :id => user_spoken_languages(:one).to_param, :user_spoken_language => { }
    assert_redirected_to user_spoken_language_path(assigns(:user_spoken_language))
  end

  test "should destroy user_spoken_language" do
    assert_difference('UserSpokenLanguage.count', -1) do
      delete :destroy, :id => user_spoken_languages(:one).to_param
    end

    assert_redirected_to user_spoken_languages_path
  end
end
