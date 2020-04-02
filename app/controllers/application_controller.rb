class ApplicationController < ActionController::Base
  include ApplicationHelper
  before_action :store_user_location!, :if => :storable_location?
  before_action :configure_permitted_parameters, :if => :devise_controller?

  private

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :phone, :show_phone_request, :show_email_request, :show_phone_service, :show_email_service, :password_confirmation, :current_password, :customer_id, :profile) }
      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :password, :phone, :show_phone_request, :show_email_request, :show_phone_service, :show_email_service, :password_confirmation, :current_password, :customer_id, :profile) }
    end
end