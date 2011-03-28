module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def current_user_info
    UserInfo.where(:user_id => current_user.id).first
  end
end
