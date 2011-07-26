require 'test_helper'

class OrganisationPostsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organisation_posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organisation_post" do
    assert_difference('OrganisationPost.count') do
      post :create, :organisation_post => { }
    end

    assert_redirected_to organisation_post_path(assigns(:organisation_post))
  end

  test "should show organisation_post" do
    get :show, :id => organisation_posts(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => organisation_posts(:one).to_param
    assert_response :success
  end

  test "should update organisation_post" do
    put :update, :id => organisation_posts(:one).to_param, :organisation_post => { }
    assert_redirected_to organisation_post_path(assigns(:organisation_post))
  end

  test "should destroy organisation_post" do
    assert_difference('OrganisationPost.count', -1) do
      delete :destroy, :id => organisation_posts(:one).to_param
    end

    assert_redirected_to organisation_posts_path
  end
end
