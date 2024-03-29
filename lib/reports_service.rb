require 'rest-client'

module ReportsService
  def get_report(flag_token)
    url = ENV['REPORTS_URL_SERVICE'] + '/reports/' + flag_token
    begin
      result = RestClient.get url, { accept: :json, Authorization: ENV['REPORTS_TOKEN_SERVICE'] }
      result.body
    rescue RestClient::ExceptionWithResponse => err
      raise
    end
  end

  def get_report_json(flag_token)
    url = ENV['REPORTS_URL_SERVICE'] + '/reports/' + flag_token + '/json'
    begin
      result = RestClient.get url, { accept: :json, Authorization: ENV['REPORTS_TOKEN_SERVICE']  }
      result.body
    rescue RestClient::ExceptionWithResponse => err
      raise
    end
  end

  def create_report(flag_token)
    url = ENV['REPORTS_URL_SERVICE'] + '/reports'
    begin
      result = RestClient.post url, { 'token' => flag_token }.to_json, { content_type: :json,
                                                                         accept: :json,
                                                                         Authorization: ENV['REPORTS_TOKEN_SERVICE'] }
      result.body
    rescue RestClient::ExceptionWithResponse => err
      raise
    end
  end

  def update_report_result(flag_token, result)
    url = ENV['REPORTS_URL_SERVICE'] + '/reports/' + flag_token + '/result'
    begin
      result = RestClient.put url, { 'result' => result }.to_json, { content_type: :json, Authorization: ENV['REPORTS_TOKEN_SERVICE'] }
      result.body
    rescue RestClient::ExceptionWithResponse => err
      raise
    end
  end

  def update_report_time(flag_token, time)
    url = ENV['REPORTS_URL_SERVICE'] + '/reports/' + flag_token + '/time'
    begin
      result = RestClient.put url, { 'time' => time }.to_json, { content_type: :json, Authorization: ENV['REPORTS_TOKEN_SERVICE'] }
      result.body
    rescue RestClient::ExceptionWithResponse => err
      raise
    end
  end

  def healthcheck_report
    url = ENV['REPORTS_URL_SERVICE'] + '/healthcheck'
    begin
      result = RestClient.get url, { accept: :json }
      return true
    rescue RestClient::ExceptionWithResponse => err
      case err.http_code
      when 404, 500, 503
        return false
      end
    end
  end
end
