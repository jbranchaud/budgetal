class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  after_filter :flash_to_headers
  def flash_to_headers
    if request.xhr?
      #avoiding XSS injections via flash
      flash_json = Hash[flash.map{|k,v| [k,ERB::Util.h(v)] }].to_json
      response.headers['X-Flash-Messages'] = flash_json
      flash.discard
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(
        :email,
        :password,
        :first_name,
        :last_name
      )
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(
        :email,
        :password,
        :password_confirmation,
        :first_name,
        :last_name,
        :current_password
      )
    end
  end
end
