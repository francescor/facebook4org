require 'test_helper'

class IndividualPostPreferredCountriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:individual_post_preferred_countries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create individual_post_preferred_country" do
    assert_difference('IndividualPostPreferredCountry.count') do
      post :create, :individual_post_preferred_country => { }
    end

    assert_redirected_to individual_post_preferred_country_path(assigns(:individual_post_preferred_country))
  end

  test "should show individual_post_preferred_country" do
    get :show, :id => individual_post_preferred_countries(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => individual_post_preferred_countries(:one).to_param
    assert_response :success
  end

  test "should update individual_post_preferred_country" do
    put :update, :id => individual_post_preferred_countries(:one).to_param, :individual_post_preferred_country => { }
    assert_redirected_to individual_post_preferred_country_path(assigns(:individual_post_preferred_country))
  end

  test "should destroy individual_post_preferred_country" do
    assert_difference('IndividualPostPreferredCountry.count', -1) do
      delete :destroy, :id => individual_post_preferred_countries(:one).to_param
    end

    assert_redirected_to individual_post_preferred_countries_path
  end
end
