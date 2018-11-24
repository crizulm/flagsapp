require 'rest-client'

module InvitesService

  def create_invite(organization_id, sender_id, email)
    url = ENV['INVITES_URL_SERVICE'] + '/invites'
    begin
      result = RestClient.post url, {'organization_id' => organization_id,
                                     'sender_id' => sender_id, 'email' => email}.to_json, {content_type: :json, accept: :json}
      result.body
    rescue RestClient::ExceptionWithResponse => err
      raise
    end
  end

  def show_invite(token)
    url = ENV['INVITES_URL_SERVICE'] + '/invites/' + token
    begin
      result = RestClient.get url, {accept: :json}
      result.body
    rescue RestClient::ExceptionWithResponse => err
      raise
    end
  end

  def destroy_invite(token)
    url = ENV['INVITES_URL_SERVICE'] + '/invites/' + token.to_s
    begin
      result = RestClient.delete url, {accept: :json}
      result.body
    rescue RestClient::ExceptionWithResponse => err
      raise
    end
  end
end