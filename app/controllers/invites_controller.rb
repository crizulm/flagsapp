require 'invites_service'

class InvitesController < ApplicationController
  include InvitesService
  before_action :authenticate_admin!, only: [:new, :create]

  def new
    @healthcheck = healthcheck_invite
    @errors = []
  end

  def create
    email = params[:email]
    organization_id = current_user.organization_id
    sender_id = current_user.id
    begin
      invite = create_invite(organization_id, sender_id, email)
      redirect_to new_invite_path
    rescue RestClient::ExceptionWithResponse => err
      handle_error(err)
    end
  end

  private

  def handle_error(err)
    @errors = JSON.parse err.response.body
    render :new
  end
end
