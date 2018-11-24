require 'reports_service'

class ReportsController < ApplicationController
  include ReportsService
  before_action :authenticate_user!, only: [:index]

  def index

  end

  def show
    flag = Flag.where(auth_token: params[:id]).first
    return render json: {data: 'Error flag not found'}, status: 400 if flag.nil?

    result = get_report_json(flag.auth_token)
    render json: result, status: :ok
  end
end
