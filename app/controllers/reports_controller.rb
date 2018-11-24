require 'reports_service'
require 'json'
require 'report'

class ReportsController < ApplicationController
  include ReportsService
  before_action :authenticate_user!, only: [:index]

  def index
    @flags = Flag.where(organization_id: current_user.organization_id)
    @flags.each do | flag |
      report_json = JSON.parse get_report(flag.auth_token)
      report = Report.new
      report.total_request = report_json['total_request']
      report.true_answer = report_json['true_answer']
      report.false_answer = report_json['false_answer']
      report.total_time = report_json['total_time']
      flag.report = report
    end
  end

  def show
    flag = Flag.where(auth_token: params[:id]).first
    return render json: {data: 'Error flag not found'}, status: 400 if flag.nil?

    result = get_report_json(flag.auth_token)
    render json: result, status: :ok
  end
end
