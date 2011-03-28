require 'test_helper'

class SavedPropertiesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => SavedProperty.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    SavedProperty.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    SavedProperty.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to saved_property_url(assigns(:saved_property))
  end

  def test_edit
    get :edit, :id => SavedProperty.first
    assert_template 'edit'
  end

  def test_update_invalid
    SavedProperty.any_instance.stubs(:valid?).returns(false)
    put :update, :id => SavedProperty.first
    assert_template 'edit'
  end

  def test_update_valid
    SavedProperty.any_instance.stubs(:valid?).returns(true)
    put :update, :id => SavedProperty.first
    assert_redirected_to saved_property_url(assigns(:saved_property))
  end

  def test_destroy
    saved_property = SavedProperty.first
    delete :destroy, :id => saved_property
    assert_redirected_to saved_properties_url
    assert !SavedProperty.exists?(saved_property.id)
  end
end
