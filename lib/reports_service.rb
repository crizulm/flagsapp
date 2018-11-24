require 'rest-client'

module ReportsService

  def get_report(flag_token)
    url = ENV['REPORTS_URL_SERVICE'] + '/reports/' + flag_token
    begin
      result = RestClient.get url, {accept: :json}
      result.body
    rescue RestClient::ExceptionWithResponse => err
      raise
    end
  end

  def get_report_json(flag_token)
    url = ENV['REPORTS_URL_SERVICE'] + '/reports/' + flag_token + '/json'
    begin
      result = RestClient.get url, {accept: :json}
      result.body
    rescue RestClient::ExceptionWithResponse => err
      raise
    end
  end

  def create_report(flag_token)
    url = ENV['REPORTS_URL_SERVICE'] + '/reports'
    begin
      result = RestClient.post url, {'token' => flag_token}.to_json, {content_type: :json, accept: :json}
      result.body
    rescue RestClient::ExceptionWithResponse => err
      raise
    end
  end

  def update_report_result(flag_token, result)
    url = ENV['REPORTS_URL_SERVICE'] + '/reports/' + flag_token + '/result'
    begin
      result = RestClient.put url, {'result' => result}.to_json, {content_type: :json}
      result.body
    rescue RestClient::ExceptionWithResponse => err
      raise
    end
  end

  def update_report_time(flag_token, time)
    url = ENV['REPORTS_URL_SERVICE'] + '/reports/' + flag_token + '/time'
    begin
      result = RestClient.put url, {'time' => time}.to_json, {content_type: :json}
      result.body
    rescue RestClient::ExceptionWithResponse => err
      raise
    end
  end
end