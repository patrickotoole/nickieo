class RegistrationsController < Devise::RegistrationsController

  def create
    super
    session[:omniauth] = nil unless @user.new_record?
  end

  def edit
    render_with_scope :edit
  end
  
  def edit_password
    render :edit_password, :locals => {:resource => current_user}
  end
  
  def update_without_password
    
    begin 
      current_password = !params[:user][:current_password].nil? ? params[:user].delete(:current_password) : nil
      if current_password.nil? || current_user.valid_password?(current_password)
        current_user.update_attributes!(params[:user]) 
        set_flash_message :notice, :updated
      else
        set_flash_message :notice, :invalid
      end
    rescue Exception => exc
      set_flash_message :notice, "Unable to store changes. #{exc.message}"
    end
    
    sign_in :user, current_user
    redirect_to user_info_path(current_user)
    
  end
  
  private
    def build_resource(*args)
      super
      if session[:omniauth]
        @user.apply_omniauth(session[:omniauth])
        @user.valid?
      end
    end

end
