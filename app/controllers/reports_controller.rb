class ReportsController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    @reports = Report.joins(:flag).where("flags.organization_id" => current_user.organization_id)
  end
end
