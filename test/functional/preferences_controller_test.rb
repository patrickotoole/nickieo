require 'test_helper'

class PreferencesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Preference.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Preference.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to preferences_url
  end

  def test_edit
    get :edit, :id => Preference.first
    assert_template 'edit'
  end

  def test_update_invalid
    Preference.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Preference.first
    assert_template 'edit'
  end

  def test_update_valid
    Preference.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Preference.first
    assert_redirected_to preferences_url
  end

  def test_destroy
    preference = Preference.first
    delete :destroy, :id => preference
    assert_redirected_to preferences_url
    assert !Preference.exists?(preference.id)
  end
end
