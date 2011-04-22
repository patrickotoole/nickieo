class PropertyPhotosController < ApplicationController
  # GET /property_photos
  # GET /property_photos.xml
  def index
    @property_photos = params[:property_id] ? PropertyPhoto.where(:property_id => params[:property_id]) : PropertyPhoto.all
    @property_id = params[:property_id]
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @property_photos }
    end
  end

  # GET /property_photos/1
  # GET /property_photos/1.xml
  def show
    @property_photo = PropertyPhoto.find(params[:id])

    puts @property_photo.inspect

    @property = params[:property_id] ? Property.find(params[:property_id]) : nil
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @property_photo }
    end
  end

  # GET /property_photos/new
  # GET /property_photos/new.xml
  def new
    @property_photo = PropertyPhoto.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @property_photo }
    end
  end

  # GET /property_photos/1/edit
  def edit
    @property_photo = PropertyPhoto.find(params[:id])
  end

  # POST /property_photos
  # POST /property_photos.xml
  def create
    @property_photo = PropertyPhoto.new(params[:property_photo])
    @property_photo.order = PropertyPhoto.where(:property_id => @property_photo.property_id).length
    
    respond_to do |format|
      if @property_photo.save
        format.html { redirect_to(@property_photo, :notice => 'Property photo was successfully created.') }
        format.xml  { render :xml => @property_photo, :status => :created, :location => @property_photo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @property_photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /property_photos/1
  # PUT /property_photos/1.xml
  def update
    @property_photo = PropertyPhoto.find(params[:id])

    respond_to do |format|
      if @property_photo.update_attributes(params[:property_photo])
        format.html { redirect_to(@property_photo, :notice => 'Property photo was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @property_photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /property_photos/1
  # DELETE /property_photos/1.xml
  def destroy
    @property_photo = PropertyPhoto.find(params[:id])
    @property_photo.destroy

    respond_to do |format|
      format.html { redirect_to(property_photos_url) }
      format.xml  { head :ok }
    end
  end
end
