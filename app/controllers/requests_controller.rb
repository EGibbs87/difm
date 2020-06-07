class RequestsController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create]
  before_action :set_request, :only => [:show, :edit, :update, :renew, :toggle_active, :destroy]
  before_action :set_classifications
  before_action :set_products, :only => [:new, :create, :edit]

  def index
    sp = search_params['q'] || {}
    @classifications = Classification.all.sort_by { |c| [(c.name == "Other") ? 1 : 0, c.name] }
    if !sp.try(:[], 'location').blank? && !params['distance'].blank?
      @q = Request.near([sp['location'], "USA"].join(", "), params['distance']).ransack(sp.except(:location))
    else
      @q = Request.ransack(search_params.except(:location))
    end
    @requests = @q.result.order(:created_at).page params[:page]
  end

  def new
    @classifications = Classification.all.sort_by { |c| [(c.name == "Other") ? 1 : 0, c.name] }
    @request = current_user.requests.new(expiration: Date.today + 1.week)
  end

  def create
    @classifications = Classification.all.sort_by { |c| [(c.name == "Other") ? 1 : 0, c.name] }
    @request = current_user.requests.new(request_params.except(:classifications, :expiration))
    c_ids = request_params[:classifications].map(&:"to_i")
    c_ids.each do |c|
      next if c < 1
      @request.classifications << @classifications.find(c)
    end
    expiration = [request_params[:expiration].to_i, current_user.posts.to_i].min
    @request.expiration = Date.today + expiration.weeks

    respond_to do |format|
      if @request.save
        unless ENV["FREE_POSTS"] = "true"
          current_user.update(posts: current_user.posts.to_i - expiration)
        end
        flash[:success] = "Request successfully created!"
        format.html { redirect_to @request }
        format.json { render :show, status: :created, location: @request }
      else
        flash[:alert] = @request.errors.messages.map { |k,v| v }.flatten.uniq.join("; ")
        format.html { render :new }
        format.json { render :json => @request.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
    if @request.user.id != current_user.id
      flash[:alert] = "You cannot edit another user's listing"
      redirect_to(dashboard_path)
    end
  end

  def renew
    if @request.user.id != current_user.id
      flash[:alert] = "You cannot edit another user's listing"
    end

    expiration = [request_params[:expiration].to_i, current_user.posts.to_i].min
    start_date = [Date.today, @request.expiration].max
    @request.expiration = start_date + expiration.weeks
    @request.active = true
    
    respond_to do |format|
      if @request.save
        unless ENV["FREE_POSTS"] = "true"
          current_user.update(posts: current_user.posts.to_i - expiration)
        end
        flash[:success] = "Request renewed!"
        format.html { redirect_to @request }
        format.js { }
      else
        flash[:alert] = @request.errors.messages.map { |k,v| v }.flatten.uniq.join("; ")
        format.html { redirect_to @request }
        format.js { }
      end
    end
  end

  def update
    if @request.user.id != current_user.id
      flash[:alert] = "You cannot edit another user's listing"
      redirect_to(dashboard_path)
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
      if @request.update(request_params.except(:classifications))
        flash[:success] = "Request successfully updated!"
        format.html { redirect_to @request }
        format.json { render :show, status: :created, location: @request }
      else
        flash[:alert] = @request.errors.messages.map { |k, v| v }.flatten.uniq.join("; ")
        format.html { render :update }
        format.json { render :json => @request.errors, :status => :unprocessable_entity }
      end
    end
  end

  def toggle_active
    if !@request.active && (Date.today > @request.expiration)
      @success = "false"
      @toggle = "off"
      flash[:notice] = "You must renew expired posts to activate"
    else
      @success = "true"
      @toggle = @request.active ? "off" : "on"
      flash[:success] = "Post has been #{@request.active ? 'deactivated' : 'activated'}"
      @request.update(active: !@request.active)
    end
    respond_to do |format|
      format.html { redirect_to @request }
      format.js { }
    end
  end

  def destroy
    if @request.user.id != current_user.id
      flash[:alert] = "You cannot edit another user's listing"
      redirect_to dashboard_path
    end

    @request.destroy
    respond_to do |format|
      flash[:success] = "Requst listing was successfully removed"
      format.html { redirect_to dashboard_path }
      format.json { head :no_content }
    end
  end

  def search
    redirect_to requests_url(search_params)
  end

  private

  def set_classifications
    @classifications = Classification.all.sort_by { |c| [(c.name == "Other") ? 1 : 0, c.name] }
  end

  def set_request
    @request = Request.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:description, :location, :range, :timeframe, :expiration, :classifications => [])
  end

  def search_params
    params.except(:button).permit(:distance, :button, :q => [:description_cont, :location, :classifications_name_eq])
  end

  def set_products
    @products = Product.all
  end
end
