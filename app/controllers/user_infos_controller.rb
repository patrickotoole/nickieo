class UserInfosController < ApplicationController
  def index
    @user_infos = UserInfo.all
  end

  def show
    @recent_properties = session[:recent_properties] != nil ? session[:recent_properties].inject([]) {|arr,x| arr.push(Property.where(:id => x).first)} : []
    @user_info = UserInfo.find(params[:id])
    if @user_info == nil 
      redirect_to(:action => 'new')
    end

  end

  def new
    @user_info = UserInfo.new(:user_id => current_user.id)
  end

  def create
    @user_info = UserInfo.new(params[:user_info])
    if @user_info.save
      flash[:notice] = "Successfully created user info."
      redirect_to @user_info
    else
      puts @user_info
      render :action => 'new'
    end
  end

  def edit
    @user_info = UserInfo.find(params[:id])
  end

  def update
    @user_info = UserInfo.find(params[:id])
    if @user_info.update_attributes(params[:user_info])
      flash[:notice] = "Successfully updated user info."
      redirect_to @user_info
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user_info = UserInfo.find(params[:id])
    @user_info.destroy
    flash[:notice] = "Successfully destroyed user info."
    redirect_to user_infos_url
  end
end
