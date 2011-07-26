require 'test_helper'

class IndividualPostsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:individual_posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create individual_post" do
    assert_difference('IndividualPost.count') do
      post :create, :individual_post => { }
    end

    assert_redirected_to individual_post_path(assigns(:individual_post))
  end

  test "should show individual_post" do
    get :show, :id => individual_posts(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => individual_posts(:one).to_param
    assert_response :success
  end

  test "should update individual_post" do
    put :update, :id => individual_posts(:one).to_param, :individual_post => { }
    assert_redirected_to individual_post_path(assigns(:individual_post))
  end

  test "should destroy individual_post" do
    assert_difference('IndividualPost.count', -1) do
      delete :destroy, :id => individual_posts(:one).to_param
    end

    assert_redirected_to individual_posts_path
  end
end
