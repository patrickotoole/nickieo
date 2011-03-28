class PropertiesController < ApplicationController
  # GET /properties
  # GET /properties.xml
  def index
    @properties = Property.all
    @featured_properties = Property.where(:featured => true).first != nil ? Property.where(:featured => true) : nil
    @recent_properties = session[:recent_properties] != nil ? session[:recent_properties].inject([]) {|arr,x| arr.push(Property.where(:id => x).first)} : []
    
    puts @recent_properties.inspect
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @properties }
    end
  end

  # GET /properties/1
  # GET /properties/1.xml
  def show
    @admin = true
    @property = Property.find(params[:id])
    update_recently_viewed

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @property }
    end
    
  end

  # GET /properties/new
  # GET /properties/new.xml
  def new
    @property = Property.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @property }
    end
  end

  # GET /properties/1/edit
  def edit
    @property = Property.find(params[:id])
  end

  # POST /properties
  # POST /properties.xml
  def create
    @property = Property.new(params[:property])
    begin
      @property.set_lat_lng(nil)
    rescue
      lat_lng_fail = 'Could not plot location on map.'
    end

    respond_to do |format|
      if @property.save
        format.html { redirect_to(@property, :notice => 'Property was successfully created. ' + lat_lng_fail) }
        format.xml  { render :xml => @property, :status => :created, :location => @property }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @property.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /properties/1
  # PUT /properties/1.xml
  def update
    @property = Property.find(params[:id])
    params[:property][:lat] == "" ? @property.set_lat_lng(params[:property]) : nil

    respond_to do |format|
      if @property.update_attributes(params[:property])
        format.html { redirect_to(@property, :notice => 'Property was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @property.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /properties/1
  # DELETE /properties/1.xml
  def destroy
    @property = Property.find(params[:id])
    @property.destroy

    respond_to do |format|
      format.html { redirect_to(properties_url) }
      format.xml  { head :ok }
    end
  end
  
  private
    def update_recently_viewed
      session[:recent_properties] ||= []
      session[:recent_properties].delete_if {|x| x == @property.id }
      session[:recent_properties].unshift(@property.id)
      
      session[:recent_properties].pop while session[:recent_properties].length > 10 
    end
end
