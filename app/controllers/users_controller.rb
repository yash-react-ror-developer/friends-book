class UsersController < ApplicationController

  def show;end

  def search_user
    @users = User.where("email like ?", "%#{params[:search]}%") if params[:search]
    render json: @users.map(&:email) if @users
  end

  def send_request
    @user = User.find_by_email(params[:email])
    @friendship = current_user.friendships.create(status: false, friend_id: @user.id, user_id: current_user.id)
    redirect_to invited_friends_path
  end

  def invited_friends
    @users = []
    @status = []
    @friendships = Friendship.where("user_id = ? OR friend_id = ?", current_user.id, current_user.id).where(status: "f")
    @friendships.each do |friendship|
      if friendship.friend_id == current_user.id
        user = User.find(friendship.user_id)
        @users.push(user)
        @status.push("received")
      else
        user = User.find(friendship.friend_id)
        @users.push(user)
        @status.push("sent")
      end
    end
  end

  def cancel_request
    @friendship = Friendship.where("user_id = ? AND friend_id = ?", current_user.id, params[:id]).first
    unless @friendship
      @friendship = Friendship.where("user_id = ? AND friend_id = ?", params[:id], current_user.id).first
    end
    @friendship.delete
    redirect_to invited_friends_path
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

  def accept_user
    @friendship = Friendship.where("user_id = ? AND friend_id = ?", params[:id], current_user.id).first
    @friendship.update(status: true)
    redirect_to friend_list_path
  end

  def friend_list
    @friends = []
    @friendships = Friendship.where("user_id = ? OR friend_id = ?", current_user.id, current_user.id).where(status: "t")
    @friendships.each do |friendship|
      if friendship.friend_id == current_user.id
        @friends.push(User.find(friendship.user_id))
      else
        @friends.push(User.find(friendship.friend_id))
      end
    end
  end
end
