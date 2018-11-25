require 'reports_service'
require 'json'
require 'report'

class ReportsController < ApplicationController
  include ReportsService
  before_action :authenticate_user!, only: [:index]

  def index
    healthcheck_service
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
    begin
      report = get_report_json(params[:id])
      render json: report, status: :ok
    rescue RestClient::ExceptionWithResponse => err
      render json: err.response.body, status: err.http_code
    end
  end

  private

  def healthcheck_service
    healthcheck = healthcheck_report
    if !healthcheck
      render 'reports/healthcheck_fail'
    end
  end
end
