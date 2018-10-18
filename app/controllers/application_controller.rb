class ApplicationController < ActionController::Base
  def authenticate_admin!
    if current_user == nil
      redirect_to home_url
    else
      redirect_to home_url unless current_user.is_admin
    end
  end
end
