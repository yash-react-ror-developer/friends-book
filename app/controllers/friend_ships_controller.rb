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
    user = User.find(params[:id])
    current_user.inverse_friendships.where(user_id: params[:id]).update(status: true)
    redirect_to view_profile_users_path(email: user.email)
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

  private
    def handle_cancel_request(friendship)
      if friendship && friendship.destroy
        flash[:notice] = "Friendship cancelled successfully"
      else
        flash[:alert] = "Something went wrong"
      end
    end

    def get_friends
      @sent_invitations = current_user.friends
      @received_invitations = current_user.inverse_friends
      # return @sent_invitations, @received_invitations
    end
end
