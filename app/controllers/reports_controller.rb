class ReportsController < ApplicationController
  def index
    @reports = Report.joins(:flag).where("flags.organization_id" => current_user.organization_id)
  end
end
