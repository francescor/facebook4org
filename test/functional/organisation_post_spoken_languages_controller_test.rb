require 'test_helper'

class OrganisationPostSpokenLanguagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organisation_post_spoken_languages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organisation_post_spoken_language" do
    assert_difference('OrganisationPostSpokenLanguage.count') do
      post :create, :organisation_post_spoken_language => { }
    end

    assert_redirected_to organisation_post_spoken_language_path(assigns(:organisation_post_spoken_language))
  end

  test "should show organisation_post_spoken_language" do
    get :show, :id => organisation_post_spoken_languages(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => organisation_post_spoken_languages(:one).to_param
    assert_response :success
  end

  test "should update organisation_post_spoken_language" do
    put :update, :id => organisation_post_spoken_languages(:one).to_param, :organisation_post_spoken_language => { }
    assert_redirected_to organisation_post_spoken_language_path(assigns(:organisation_post_spoken_language))
  end

  test "should destroy organisation_post_spoken_language" do
    assert_difference('OrganisationPostSpokenLanguage.count', -1) do
      delete :destroy, :id => organisation_post_spoken_languages(:one).to_param
    end

    assert_redirected_to organisation_post_spoken_languages_path
  end
end
