class SavedPropertiesController < ApplicationController
  def index
    @saved_properties = SavedProperty.all
  end

  def show
    @saved_property = SavedProperty.find(params[:id])
  end

  def new
    @saved_property = SavedProperty.new
  end

  def create
    @saved_property = SavedProperty.find_or_create_by_user_id_and_property_id(params[:user_id], params[:property_id])
       if @saved_property.save
         flash[:notice] = "Successfully created saved property."
         redirect_to @saved_property.property
       else
         render :action => 'new'
       end
  end

  def edit
    @saved_property = SavedProperty.find(params[:id])
  end

  def update
    @saved_property = SavedProperty.find(params[:id])
    if @saved_property.update_attributes(params[:saved_property])
      flash[:notice] = "Successfully updated saved property."
      redirect_to @saved_property
    else
      render :action => 'edit'
    end
  end

  def destroy
    @saved_property = SavedProperty.find(params[:id])
    @saved_property.destroy
    flash[:notice] = "Successfully destroyed saved property."
    redirect_to saved_properties_url
  end
end
