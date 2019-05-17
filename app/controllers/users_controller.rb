class UsersController < ApplicationController

  def show;end

  def search_user
    @users = User.where("email like ? AND  activate = ?", "%#{params[:search]}%", true) if params[:search]
    @search_result = []
    if @users
      @users.each do |user|
        if current_user.friendships.find_by_friend_id(user.id) || current_user.inverse_friendships.find_by_user_id(user.id)
          @search_result.push({email: user.email, status: 'requested'})
        else
          if current_user.id != user.id
            @search_result.push({email: user.email, status: 'not requested'})
          end
        end
      end
      render json: @search_result
    else
      render 'search_user'
    end

  end

  def update
    current_user.avatar.attach(params[:user][:avatar])
    redirect_to user_path
  end

  def view_profile
    @user = User.where(email: params[:email]).first
    if current_user.friendships.where(friend_id: @user.id, status: false).first
      @status = "sent"
    elsif current_user.inverse_friendships.where(user_id: @user.id, status: false).first
      @status = "received"
    elsif current_user.friendships.where(friend_id: @user.id, status: true).first
      @status = "friends"
      @flag = "sent"
    elsif current_user.inverse_friendships.where(user_id: @user.id, status: true).first
      @status = "friends"
      @flag = "received"
    else
      @status = "nota"
    end
  end


end
