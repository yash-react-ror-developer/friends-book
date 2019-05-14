class InvitationMailJob < ApplicationJob
  queue_as :default

  def perform(contact)
    InvitationMailer.invite_user(contact.email).deliver
  end
end
