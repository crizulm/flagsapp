class ApplicationController < ActionController::Base
  def authenticate_admin!
    redirect_to home_index_url unless current_user.is_admin
  end
end
