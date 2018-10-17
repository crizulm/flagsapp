class InvitesController < ApplicationController

  def new
    @invite = Invite.new
  end

  def create
    @invite = Invite.new(invite_params)
    @invite.organization_id = current_user.organization_id
    @invite.sender_id = current_user.id
    if @invite.save
      InviteMailer.new_user_invite(@invite, new_user_registration_path(:invite_token => @invite.token)).deliver
      redirect_to new_invite_path
    else
      render :new
    end
  end

  private
  def invite_params
    params.require(:invite).permit(:email)
  end
end
