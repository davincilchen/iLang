class ApplicationController < ActionController::Base


  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :authenticate_user!
  protect_from_forgery with: :exception

  protected

  # Devise 客製化屬性的使用說明：  https://github.com/plataformatec/devise#strong-parameters

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :password, :password_confirmation])
  end
  
end
