class AdminController < ApplicationController
  before_action :get_user, only: [:activate_user, :deactivate_user, :delete_user]
  before_action :get_users, only: [:show_users]

  # def show_users;end

  def activate_user
    if @user.update(activate: true) # User Enum
      flash[:notice] = "user activated successfully" # I18n
    else
      flash[:alert] = "something went wrong"
    end
  end

  def deactivate_user
    if @user.update(activate: false)
      flash[:notice] = "user deactivated successfully"
    else
      flash[:alert] = "something went wrong"
    end
  end

  def delete_user
    if @user.destroy
      flash[:notice] = "user deleted successfully"
    else
      flash[:alert] = "something went wrong"
    end
  end

  private
    def get_user
      @user = User.find(params[:id])
    end

    def get_users
      @users = User.where(role: "user").paginate(page: params[:page], per_page: 10) #User Enum
    end
end
