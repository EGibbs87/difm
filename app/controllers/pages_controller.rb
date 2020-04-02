class PagesController < ApplicationController
  def home
    @classifications = Classification.all
    @recent_services = Service.all.sort_by(&:created_at).first(10)
    @recent_requests = Request.all.sort_by(&:created_at).first(10)
    @q = Service.ransack(params[:q])
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
      redirect_to root_url, :alert => "Error: invalid request"
    end
  end

  def cert
    render '/certs/cert'
  end

  private

  def search_params
    params.except(:button).permit(:distance, :button, :q => [:description_cont, :location, :classifications_name_eq])
  end
end
