class InviteMailer < ApplicationMailer

  def new_user_invite(invite, url)
    @invite = invite
    @url = url
    mail(to: invite.email, subject: 'You are invited to join - Flagsapp')
  end
end
