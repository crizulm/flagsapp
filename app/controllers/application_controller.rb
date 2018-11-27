class ApplicationController < ActionController::Base
  def authenticate_admin!
    (current_user == nil) ? redirect_to home_url : redirect_to home_url unless current_user.is_admin
  end
end
