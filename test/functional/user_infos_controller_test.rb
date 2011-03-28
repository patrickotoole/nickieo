require 'test_helper'

class UserInfosControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => UserInfo.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    UserInfo.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    UserInfo.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to user_info_url(assigns(:user_info))
  end

  def test_edit
    get :edit, :id => UserInfo.first
    assert_template 'edit'
  end

  def test_update_invalid
    UserInfo.any_instance.stubs(:valid?).returns(false)
    put :update, :id => UserInfo.first
    assert_template 'edit'
  end

  def test_update_valid
    UserInfo.any_instance.stubs(:valid?).returns(true)
    put :update, :id => UserInfo.first
    assert_redirected_to user_info_url(assigns(:user_info))
  end

  def test_destroy
    user_info = UserInfo.first
    delete :destroy, :id => user_info
    assert_redirected_to user_infos_url
    assert !UserInfo.exists?(user_info.id)
  end
end
