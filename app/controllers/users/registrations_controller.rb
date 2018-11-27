# frozen_string_literal: true

require 'invites_service'

class Users::RegistrationsController < Devise::RegistrationsController
  include InvitesService
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super do
      @token = params[:invite_token]
      @errors_service = []
      return healthcheck_service unless @token.nil?
    end
  end

  # POST /resource
  def create
    super do
      @token = params[:invite_token]
      !@token.nil? ? create_with_invitation : create_simple
    end
  end

  def create_with_invitation
    begin
      invite_json = JSON.parse show_invite(@token)
      organization = Organization.find_by(id: invite_json['organization_id'])
      resource.organization = organization
      resource.is_admin = false
      @errors_service = []
      destroy_invite(invite_json['id']) if resource.save
    rescue RestClient::ExceptionWithResponse => err
      @errors_service = JSON.parse err.response.body
    end
  end

  def healthcheck_service
    healthcheck = healthcheck_invite
    render 'users/registrations/healthcheck_fail' unless healthcheck
  end

  def create_simple
    organization = Organization.new
    organization.name = params[:organization_name]
    organization.save
    resource.organization = organization
    resource.is_admin = true
    @errors_service = []
    resource.save
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #  super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer().permit(:sign_up, keys: [:name, :surname, :picture, :invite_token, :organization_name])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer().permit(:account_update, keys: [:name, :surname])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
