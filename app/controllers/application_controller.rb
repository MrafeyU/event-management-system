class ApplicationController < ActionController::Base
  include Pundit::Authorization
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :turbo_frame_request_variant
  
  add_flash_types :info, :error, :success

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized
  rescue_from Pundit::NotDefinedError, with: :not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # decide where to redirect users after login based on their role...
  def after_sign_in_path_for(user)
    if user.is_a?(Admin)
      admin_root_path
    elsif user.is_a?(Organizer)
      organizer_root_path
    elsif  user.is_a?(Attendee)
      attendee_root_path  
    else 
      root_path
    end 
  end
  
  # add the user's role to the URL parameters for use in routing.. 
  def default_url_options
    if current_user.is_a?(Admin)
      {role: "admin"}
    elsif current_user.is_a?(Organizer)
      {role: "organizer"}     
    elsif  current_user.is_a?(Attendee)
      {role: "attendee"}
    else
      {}  
    end
  end

  protected
  def not_authorized
    redirect_to root_path, alert: "You are not authorized to perform this action."
  end

  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :type, :avatar ])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar ])
  end

  def record_not_found
    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end
end
