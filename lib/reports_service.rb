require 'rest-client'

module ReportsService

  def get_report

  end

  def get_report_json

  end

  def post_report(flag_id)
    url = ENV['REPORTS_URL_SERVICE'] + '/reports'
    RestClient.post url, {'flag_id'=> flag_id }.to_json, {content_type: :json, accept: :json}
  end

  def put_report

  end
end