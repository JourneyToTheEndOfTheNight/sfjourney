class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :user_signed_in?

  private
    def current_user
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    end

    def is_admin?
      current_user && current_user.email && (ENV['AUTHORIZED_USERS'].include?(current_user.email))
    end

    def require_admin!
      if !current_user
        flash[:error] = 'You need to sign in before accessing this page!'
        redirect_to signin_services_path
      elsif !is_admin?
        flash[:error] = 'Only admins can access this page!'
        redirect_to signin_services_path
      end
    end

    def user_signed_in?
      return 1 if current_user
    end

    def authenticate_user!
      if !current_user
        flash[:error] = 'You need to sign in before accessing this page!'
        redirect_to signin_services_path
      end
    end
end
