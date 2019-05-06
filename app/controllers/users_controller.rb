class UsersController < ApplicationController
  def show;end

  def search_user
    @user = User.find_by(email: params[:search])
    if @user
      @friendship = Friendship.where("user_id = ? AND friend_id = ?", current_user.id, @user.id).first
    end
  end

  def send_request
    @friendship = current_user.friendships.create(status: false, friend_id: params[:user_id], user_id: current_user.id)
    @user = User.find(params[:user_id])
  end

  def cancel_request
    Friendship.where("user_id = ? AND friend_id = ?", current_user.id, params[:user_id]).first.delete
    @user = User.find(params[:user_id])
  end

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
