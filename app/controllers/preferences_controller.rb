class PreferencesController < ApplicationController
  def index
    @preferences = Preference.all
  end

  def new
    @preference = Preference.new
  end

  def create
    @preference = Preference.new(params[:preference])
    if @preference.save
      flash[:notice] = "Successfully created preference."
      redirect_to preferences_url
    else
      render :action => 'new'
    end
  end

  def edit
    @preference = Preference.find(params[:id])
  end

  def update
    @preference = Preference.find(params[:id])
    if @preference.update_attributes(params[:preference])
      flash[:notice] = "Successfully updated preference."
      redirect_to preferences_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @preference = Preference.find(params[:id])
    @preference.destroy
    flash[:notice] = "Successfully destroyed preference."
    redirect_to preferences_url
  end
end
