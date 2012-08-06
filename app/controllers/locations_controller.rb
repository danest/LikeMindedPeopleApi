class LocationsController < ApplicationController
  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @locations }
    end
  end
  
  def index_filter
    @user = User.where(fb_id: params[:fb_id]).first
    location_filter = JSON.parse(params[:location_filter])
    moment = location_filter['moment']
    @locations = Location.within(location_filter['filter'], :origin => [location_filter['latitude'],location_filter['longitude']])
    locations_details = get_location_details(moment, @locations)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: locations_details }
    end
  end
  
  def index_google
    #@user = User.where(fb_id: params[:fb_id]).first
    
    @client = GooglePlaces::Client.new('AIzaSyB1dI5uqHCX2lSjKJBqcz8DUD_VcpXmCbI')
    location_google = JSON.parse(params[:location_google])
    google_locations = @client.spots(location_google['latitude'],location_google['longitude'], :types => location_google['type'], :name => location_google['name'])
    radius = 25
    @locations_api = google_locations.map{|l| {name: l.name, latitude: l.lat, longitude: l.lng, types: l.types, radius: radius}}
    sync_locations(@locations_api)
    
    @locations_app = google_locations.map{|l| {name: l.name, latitude: l.lat, longitude: l.lng, radius: radius}}
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @locations_app }
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = Location.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.json
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: "#{t('activerecord.successful.messages.created', model: @location.class.model_name.human)}" }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to @location, notice: "#{t('activerecord.successful.messages.updated', model: @location.class.model_name.human)}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end
  
  
  private
  
  def get_location_details(moment, locations)
    location_details = Array.new
    
    locations.each do |l|
      if (moment == "Now")
        location_details << {latitude: l.latitude, longitude: l.longitude, radius: l.radius, important_characteristics: l.important_characteristics, people_now_count: people_now_count(l)}
      elsif (moment == "History")
        location_details << {latitude: l.latitude, longitude: l.longitude, radius: l.radius, important_characteristics: l.important_characteristics, people_history_count: people_history_count(l)}
      end
    end
    
    location_details
  end
  
  def people_now_count(location)
    male_count = 0
    female_count = 0
    
    User.all.each do |u|
      if (u.current_location == location)
        (male_count = male_count + 1) if (u.profiles.includes(:characteristic).where('characteristics.attributeCategories = ?', "Male").first.present? ? u.profiles.includes(:characteristic).where('characteristics.attributeCategories = ?', "Male").first.could_be : false)
        (female_count = female_count + 1) if (u.profiles.includes(:characteristic).where('characteristics.attributeCategories = ?', "Female").first.present? ? u.profiles.includes(:characteristic).where('characteristics.attributeCategories = ?', "Female").first.could_be : false)
      end
    end
    total_count = male_count + female_count
    
    {total: total_count, male: male_count, female: female_count}
  end
  
  def people_history_count(location)
    male_count = 0
    female_count = 0
    
    User.all.each do |u|
      u.interest_points.where('rank != 0').each do |i|
        if (i.location == location)
          (male_count = male_count + 1) if (u.profiles.includes(:characteristic).where('characteristics.attributeCategories = ?', "Male").first.present? ? u.profiles.includes(:characteristic).where('characteristics.attributeCategories = ?', "Male").first.could_be : false)
        (female_count = female_count + 1) if (u.profiles.includes(:characteristic).where('characteristics.attributeCategories = ?', "Female").first.present? ? u.profiles.includes(:characteristic).where('characteristics.attributeCategories = ?', "Female").first.could_be : false)
        end
      end
     end
     total_count = male_count + female_count
    
    {total: total_count, male: male_count, female: female_count}
  end
  
  def sync_locations(locations)
    locations.each do |l|
      location = Location.where(longitude: l[:longitude], latitude: l[:latitude]).first
      if location.blank?
        location = Location.create!(longitude: l[:longitude], latitude: l[:latitude], name: l[:name], radius: l[:radius])
      else
        location.update_attributes!(name: l[:name], radius: l[:radius])
      end
      
      l[:types].each do |t|
        category = Category.find_or_create_by_name(t)
        (location.categories << category) unless (location.categories.include?(category))
      end
    end
  end
  
end
