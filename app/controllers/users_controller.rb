class UsersController < ApplicationController
  def show;end

  def update
    current_user.avatar.attach(params[:user][:avatar])
    redirect_to user_path
  end

  def friends
    if current_user.contacts.count == 0
      @contacts = request.env['omnicontacts.contacts']
      if @contacts
        @contacts.each do |contact|
          current_user.contacts.create(email: contact[:email], name: contact[:name], status: "invite")
        end
      end
    end
    @contacts = current_user.contacts
  end

  def send_invitation
    @contact = Contact.find(params[:id])
    InvitationMailer.invite_user(@contact.email).deliver
    @contact.update(status: "invited")
    redirect_to friends_path
  end
end
