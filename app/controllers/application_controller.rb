class ApplicationController < ActionController::Base
  def authenticate_admin!
    unless current_user.is_admin
      redirect_to home_index_url
    end
  end
end
