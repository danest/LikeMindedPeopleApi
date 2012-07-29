class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    user_profile = JSON.parse(params[:user_profile])
    @user = User.find_or_create_by_fb_id(user_profile['user'])

    respond_to do |format|
      if @user.save
        create_profile(@user, user_profile['profile'])
        
        format.html { redirect_to @user, notice: "#{t('activerecord.successful.messages.created', model: @user.class.model_name.human)}" }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.where(fb_id: params[:id]).first

    respond_to do |format|
      if sync_pois(@user,JSON.parse(params[:pois])['pois'])
        format.html { redirect_to @user, notice: "#{t('activerecord.successful.messages.updated', model: @user.class.model_name.human)}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  
  private
  
  def create_profile(user, profile)
    profile.each do |c|
      characteristic = Characteristic.where(key: c['key'], attributeCategories: c['attributeCategories']).first
      characteristic = Characteristic.create!(key: c['key'], attributeCategories: c['attributeCategories']) if characteristic.blank?
      profile = user.profiles.where(characteristic_id: characteristic.id).first
      if profile.present?
        profile.update_attributes!(likelihood: c['likelihood'])
      else
        profile = Profile.create(characteristic_id: characteristic.id, likelihood: c['likelihood'])
        user.profiles << profile
      end
    end
  end
  
  def sync_pois(user, pois)
    pois.each do |poi|
      location = Location.where(longitude: poi['longitude'], latitude: poi['latitude'], radius: poi['radius']).first
      location = Location.create!(longitude: poi['longitude'], latitude: poi['latitude'], radius: poi['radius']) if location.blank?
      interest_point = user.interest_points.where(location_id: location.id).first
      if interest_point.present?
        interest_point.update_attributes!(rank: poi['rank'])
      else
        interest_point = InterestPoint.create(location_id: location.id, rank: poi['rank'])
        user.interest_points << interest_point
      end
    end
    
    true
  end
  
end
