class InvitationMailer < ApplicationMailer
  default from: "yash.joshi@gemsessence.com"

  def invite_user(email)
    mail(to: email, subject: "Invitation from friends book")
  end
end
