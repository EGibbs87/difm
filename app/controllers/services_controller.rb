class ServicesController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create]
  before_action :set_service, :only => [:show, :edit, :update, :destroy]
  before_action :set_classifications

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
    @service = current_user.services.new
  end

  def create
    @classifications = Classification.all
    @service = current_user.services.new(service_params.except(:classifications))
    c_ids = service_params[:classifications].map(&:"to_i")
    c_ids.each do |c|
      next if c < 1
      @service.classifications << @classifications.find(c)
    end

    respond_to do |format|
      if @service.save
        format.html { redirect_to @service, notice: "Service successfully created" }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new, :alert => @service.errors }
        format.json { render :json => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
    if @service.user.id != current_user.id
      redirect_to(dashboard_path, :alert => "You cannot edit another user's listing")
    end
  end

  def update
    if @service.user.id != current_user.id
      redirect_to(dashboard_path, :alert => "You cannot edit another user's listing")
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
      if @service.update(service_param.except(:classifications))
        format.html { redirect_to @service, notice: "Service successfully updated" }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :update, :notice => @service.errors }
        format.json { render :json => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    if @service.user.id != current_user.id
      redirect_to dashboard_path, :alert => "You cannot edit another user's listing"
    end

    @service.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_path, :notice => 'Service listing was successfully destroyed' }
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
    params.require(:service).permit(:description, :location, :range, :availability, :classifications => [])
  end

  def search_params
    params.except(:button).permit(:distance, :button, :q => [:description_cont, :location, :classifications_name_eq])
  end
end
