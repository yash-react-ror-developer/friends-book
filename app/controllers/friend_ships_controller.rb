class FriendShipsController < ApplicationController

  def send_request
    @user = User.find(params[:id])
    if @user
      friendship = current_user.friendships.create(friend_id: @user.id, status: false)
    else
    end
  end

  def invited_users
    get_friends
  end

  def accept_user
    @user = User.find(params[:id])
    if current_user.inverse_friendships.where(user_id: params[:id]).update(status: true)
      flash[:notice] = "Friendship accept successfully"
    else
      flash[:alert] = "something went wrong"
    end
  end

  def friend_list
    @friends = Friendship.get_friends(current_user)
  end

  def cancel_request
    @flag = params[:page_flag]
    @user = User.find(params[:id])
    if params[:flag] == 'received'
      friendship = current_user.inverse_friendships.find_by_user_id(params[:id])
      handle_cancel_request(friendship)
    else
      friendship = current_user.friendships.find_by_friend_id(params[:id])
      handle_cancel_request(friendship)
    end
    get_friends
  end

  def invite_friends
    @contacts = request.env['omnicontacts.contacts'] || []
    @contacts.each do |contact|
      current_user.contacts.find_or_create_by(email: contact[:email])
    end
    # binding.pry

    # current_user.contacts.find_or_create_by(email: @contacts.pluck(:emails).flatten.pluck(:email))

    @contacts = current_user.contacts.paginate(page: params[:page], per_page: 10)
  end

  def send_invitation
    contact = Contact.find(params[:id])
    job_id = InvitationMailJob.perform_later(contact)
    redirect_to friends_path
  end

  private
    def handle_cancel_request(friendship)
      if friendship && friendship.destroy
        flash[:notice] = "Friendship cancelled successfully"
      else
        flash[:alert] = "Something went wrong"
      end
    end

    def get_friends
      @sent_invitations = []
      @received_invitations = []
      current_user.friendships.where(status: false).each do |friendship|
        @sent_invitations.push(User.find(friendship.friend_id))
      end

      current_user.inverse_friendships.where(status: false).each do |friendship|
        @received_invitations.push(User.find(friendship.user_id))
      end
    end
end
