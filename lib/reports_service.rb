require 'rest-client'

module ReportsService

  def get_report

  end

  def get_report_json(flag_token)
    url = ENV['REPORTS_URL_SERVICE'] + '/reports/' + flag_token + '/json'
    result = RestClient.get url, { accept: :json }
    result.body
  end

  def create_report(flag_token)
    url = ENV['REPORTS_URL_SERVICE'] + '/reports'
    result = RestClient.post url, { 'token' => flag_token }.to_json, { content_type: :json, accept: :json }
    result.body
  end

  def update_report_result(flag_token, result)
    url = ENV['REPORTS_URL_SERVICE'] + '/reports/' + flag_token + '/result'
    result = RestClient.put url, { 'result' => result }.to_json, { content_type: :json }
    result.body
  end

  def update_report_time(flag_token, time)
    url = ENV['REPORTS_URL_SERVICE'] + '/reports/' + flag_token + '/time'
    result = RestClient.put url, { 'time' => time }.to_json, { content_type: :json }
    result.body
  end
end