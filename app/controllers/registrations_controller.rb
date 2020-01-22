class RegistrationsController < Devise::RegistrationsController

  protected

  def after_update_path_for(resource)
    edit_registration_path(current_user)
  end
end
