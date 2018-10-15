class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    @flags = Flag.where(organization_id: current_user.organization_id).includes(:organization)
  end

end
