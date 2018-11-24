require 'rest-client'

module ReportsService

  def get_report

  end

  def get_report_json(flag_id)
    url = ENV['REPORTS_URL_SERVICE'] + '/reports/' + flag_id + '/json'
    result = RestClient.get url, {accept: :json}
    result.body
  end

  def post_report(flag_id)
    url = ENV['REPORTS_URL_SERVICE'] + '/reports'
    RestClient.post url, {'flag_id' => flag_id}.to_json, {content_type: :json, accept: :json}
  end

  def put_report_result(flag_id, result)
    url = ENV['REPORTS_URL_SERVICE'] + '/reports/' + flag_id + '/result'
    RestClient.put url, {'result' => result}.to_json, {content_type: :json}
  end

  def put_report_time(flag_id, time)
    url = ENV['REPORTS_URL_SERVICE'] + '/reports/' + flag_id + '/time'
    RestClient.put url, {'time' => time}.to_json, {content_type: :json}
  end
end