# Contains methods and actions needed by multiple controllers.
# All controllers extend ApplicationController.
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :update_last_activity, except: [:poll]

  def poll # format.js
    @offline = params[:offline]
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |sign_up|
      sign_up.permit(:username, :email, :birthday, :zip_code, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |account_update|
      account_update.permit(:username, :email, :zip_code, :password, :password_confirmation, :current_password)
    end
  end

  def check_if_blocked
    redirect_to(root_path) if @user.blocked.include? current_user
  end

  def update_last_activity
    current_user.try :touch
  end
end
