require 'test_helper'

class PropertyPhotosControllerTest < ActionController::TestCase
  setup do
    @property_photo = property_photos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:property_photos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create property_photo" do
    assert_difference('PropertyPhoto.count') do
      post :create, :property_photo => @property_photo.attributes
    end

    assert_redirected_to property_photo_path(assigns(:property_photo))
  end

  test "should show property_photo" do
    get :show, :id => @property_photo.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @property_photo.to_param
    assert_response :success
  end

  test "should update property_photo" do
    put :update, :id => @property_photo.to_param, :property_photo => @property_photo.attributes
    assert_redirected_to property_photo_path(assigns(:property_photo))
  end

  test "should destroy property_photo" do
    assert_difference('PropertyPhoto.count', -1) do
      delete :destroy, :id => @property_photo.to_param
    end

    assert_redirected_to property_photos_path
  end
end
