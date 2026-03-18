class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?


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

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :type, :avatar ])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar ])
  end

end
