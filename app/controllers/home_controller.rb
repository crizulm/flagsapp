class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    @flags = Flag.where(organization_id: current_user.organization_id, is_deleted: false).limit(5)
  end

end
