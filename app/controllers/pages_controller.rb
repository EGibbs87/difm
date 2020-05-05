class PagesController < ApplicationController
  def home
    @classifications = Classification.all
    @recent_services = Service.all.sort_by(&:created_at).first(10)
    @recent_requests = Request.all.sort_by(&:created_at).first(10)
    @q = Service.ransack(params[:q])
    if !user_signed_in?
      flash[:success] = "Limited time offer: Receive 4 free posts when you sign up!"
    end
    render 'pages/home'
  end

  def about
    render 'pages/about'
  end

  def dashboard
    @services = current_user.services
    @requests = current_user.requests
    render 'pages/dashboard'
  end

  def search
    if params.keys.include?("service")
      redirect_to search_services_url(search_params)
    elsif params.keys.include?("requests")
      redirect_to search_requests_url(search_params)
    else
      flash[:alert] = "Error: Invalid request"
      redirect_to root_url
    end
  end

  def cert
    render plain: "#{params[:id]}.gHP6Fo2uP6nbs7PgSdthl4jBAjUsIKZ795LZ78ajMM8"
  end

  private

  def search_params
    params.except(:button).permit(:distance, :button, :q => [:description_cont, :location, :classifications_name_eq])
  end
end
