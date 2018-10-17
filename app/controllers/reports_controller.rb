class ReportsController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    @reports = Report.joins(:flag).where("flags.organization_id" => current_user.organization_id)
  end

  def reports_json
    @flag = Flag.where(auth_token: params[:id]).first
    return render json: { data: 'Error flag not found' }, status: 400 if @flag.nil?

    @report = Report.where(flag_id: @flag.id).first
    @json_report = get_json(@report)
    render json: { data: @json_report }, status: :ok
  end

  private

  def get_json(report)
    @return = { 'Total' => report.total_request,
                'Positive' => (report.total_request.positive? ? (report.true_answer * 100) / report.total_request : 0),
                'Negative' => (report.total_request.positive? ? (report.false_answer * 100) / report.total_request : 0),
                'Positive/Negative Rate' => (report.false_answer.positive? ? report.true_answer / report.false_answer : report.true_answer),
                'Average Response Time' => (report.total_request.positive? ? report.total_time / report.total_request : 0) }
  end
end
