class ServicesController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create]
  before_action :set_service, :only => [:show, :edit, :update, :renew, :toggle_active, :destroy]
  before_action :set_classifications
  before_action :set_products, :only => [:new, :create, :edit]

  def index
    sp = search_params['q'] || {}
    @classifications = Classification.all
    if !sp.try(:[], 'location').blank? && !params['distance'].blank?
      @q = Service.near([sp['location'], "USA"].join(", "), params['distance']).ransack(sp.except(:location))
    else
      @q = Service.ransack(sp.except(:location))
    end
    @services = @q.result.order(:created_at).page params[:page]
  end

  def new
    @classifications = Classification.all
    @service = current_user.services.new(expiration: Date.today + 1.week)
  end

  def create
    @classifications = Classification.all
    @service = current_user.services.new(service_params.except(:classifications))
    c_ids = service_params[:classifications].map(&:"to_i")
    c_ids.each do |c|
      next if c < 1
      @service.classifications << @classifications.find(c)
    end
    expiration = [service_params[:expiration].to_i, current_user.posts.to_i].min
    @service.expiration = Date.today + expiration.weeks

    respond_to do |format|
      if @service.save
        unless ENV["FREE_POSTS"] = "true"
          current_user.update(posts: current_user.posts.to_i - expiration)
        end
        flash[:success] = "Service successfully created"
        format.html { redirect_to @service }
        format.json { render :show, status: :created, location: @service }
      else
        flash[:alert] = @service.errors.messages.map { |k,v| v }.flatten.uniq.join("; ")
        format.html { render :new }
        format.json { render :json => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
    if @service.user.id != current_user.id
      flash[:alert] = "You cannot edit another user's listing"
      redirect_to(dashboard_path)
    end
  end

  def renew
    if @service.user.id != current_user.id
      flash[:alert] = "You cannot edit another user's listing"
    end

    expiration = [service_params[:expiration].to_i, current_user.posts.to_i].min
    start_date = [Date.today, @service.expiration].max
    @service.expiration = start_date + expiration.weeks
    @service.active = true
    
    respond_to do |format|
      if @service.save
        unless ENV["FREE_POSTS"] = "true"
          current_user.update(posts: current_user.posts.to_i - expiration)
        end
        flash[:success] = "Listing renewed!"
        format.html { redirect_to @service }
        format.js { }
      else
        flash[:alert] = @service.errors.messages.map { |k,v| v }.flatten.uniq.join("; ")
        format.html { redirect_to @service }
        format.js { }
      end
    end
  end

  def update
    if @service.user.id != current_user.id
      flash[:alert] = "You cannot edit another user's listing"
      redirect_to(dashboard_path)
    end

    # collect appropriate classification IDs
    c_ids = service_params[:classifications].map(&:"to_i")
    # collect IDs that need to be removed
    rm_ids = @service.classifications.map(&:id) - c_ids
    # add c_ids to @service
    c_ids.each do |c|
      next if c < 1
      rm_ids.delete(c)
      @service.classifications << @classifications.find(c)
    end

    # remove rm_ids from @service
    rm_ids.each do |c|
      @service.classifications.delete(c)
    end

    respond_to do |format|
      if @service.update(service_params.except(:classifications))
        flash[:success] = "Service successfully updated"
        format.html { redirect_to @service }
        format.json { render :show, status: :created, location: @service }
      else
        set_products
        flash[:alert] = @service.errors.messages.map { |k,v| v }.flatten.uniq.join("; ")
        format.html { render :edit }
        format.json { render :json => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  def toggle_active
    if !@service.active && (Date.today > @service.expiration)
      @success = "false"
      @toggle = "off"
      flash[:notice] = "You must renew expired posts to activate"
    else
      @success = "true"
      @toggle = @service.active ? "off" : "on"
      flash[:success] = "Post has been #{@service.active ? 'deactivated' : 'activated'}"
      @service.update(active: !@service.active)
    end
    respond_to do |format|
      format.html { redirect_to @service }
      format.js { }
    end
  end

  def destroy
    if @service.user.id != current_user.id
      flash[:alert] = "You cannot edit another user's listing"

      redirect_to dashboard_path
    end

    @service.destroy
    respond_to do |format|
      flash[:success] = "Service listing was successfully removed"
      format.html { redirect_to dashboard_path }
      format.json { head :no_content }
    end
  end

  def search
    redirect_to services_url(search_params)
  end

  private

  def set_classifications
    @classifications = Classification.all
  end

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:description, :location, :range, :availability, :expiration, :classifications => [])
  end

  def search_params
    params.except(:button).permit(:distance, :button, :q => [:description_cont, :location, :classifications_name_eq])
  end

  def set_products
    @products = Product.all
  end

end
