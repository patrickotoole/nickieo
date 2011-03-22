class InfosController < ApplicationController
  def index
    @current_user = current_user
    @featured_properties = Property.where(:featured => true).first != nil ? Property.where(:featured => true) : nil
    @welcome_image = true
  end
  def about

  end
end
