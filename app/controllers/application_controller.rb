class ApplicationController < ActionController::Base
  protect_from_forgery
  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(User)
      user_info_path(UserInfo.where(:user_id => resource_or_scope.id).first)
    else
      super
    end
  end
  

end
