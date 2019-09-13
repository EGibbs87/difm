class RequestsController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create]
  before_action :set_request, :only => [:show, :edit, :update, :destroy]
  before_action :set_classifications

  def index
    sp = search_params['q'] || {}
    @classifications = Classification.all
    if !sp.try(:[], 'location').blank? && !params['distance'].blank?
      @q = Request.near([sp['location'], "USA"].join(", "), params['distance']).ransack(sp.except(:location))
    else
      @q = Request.ransack(search_params.except(:location))
    end
    @requests = @q.result.order(:created_at).page params[:page]
  end

  def new
    @classifications = Classification.all
    @request = current_user.requests.new
  end

  def create
    @classifications = Classification.all
    @request = current_user.requests.new(request_params.except(:classifications))
    c_ids = request_params[:classifications].map(&:"to_i")
    c_ids.each do |c|
      next if c < 1
      @request.classifications << @classifications.find(c)
    end

    respond_to do |format|
      if @request.save
        format.html { redirect_to @request, notice: "Request successfully created" }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new, :alert => @request.errors }
        format.json { render :json => @request.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
    if @request.user.id != current_user.id
      redirect_to(dashboard_path, :alert => "You cannot edit another user's listing")
    end
  end

  def update
    if @request.user.id != current_user.id
      redirect_to(dashboard_path, :alert => "You cannot edit another user's listing")
    end

    # collect appropriate classification IDs
    c_ids = request_params[:classifications].map(&:"to_i")
    # collect IDs that need to be removed
    rm_ids = @request.classifications.map(&:id) - c_ids
    # add c_ids to @request
    c_ids.each do |c|
      next if c < 1
      rm_ids.delete(c)
      @request.classifications << @classifications.find(c)
    end

    # remove rm_ids from @request
    rm_ids.each do |c|
      @request.classifications.delete(c)
    end

    respond_to do |format|
      if @request.update(request_param.except(:classifications))
        format.html { redirect_to @request, notice: "Request successfully updated" }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :update, :notice => @request.errors }
        format.json { render :json => @request.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    if @request.user.id != current_user.id
      redirect_to dashboard_path, :alert => "You cannot edit another user's listing"
    end

    @request.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_path, :notice => 'Request listing was successfully destroyed' }
      format.json { head :no_content }
    end
  end

  def search
    redirect_to requests_url(search_params)
  end

  private

  def set_classifications
    @classifications = Classification.all
  end

  def set_request
    @request = Request.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:description, :location, :range, :timeframe, :classifications => [])
  end

  def search_params
    params.except(:button).permit(:distance, :button, :q => [:description_cont, :location, :classifications_name_eq])
  end
end
