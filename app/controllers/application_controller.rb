class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  def raise_not_found
    render file: 'public/404', status: 404, formats: [:html]
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  def after_sign_in_path_for(resource)
    if resource.role == 'admin' #Enum
      show_users_path
    else
      feeds_path
    end
  end
end
