class FeedsController < ApplicationController
  before_action :get_feed, only: [:edit, :update, :show, :destroy]

  def index
    filter_feeds
  end

  def new
    @feed = current_user.feeds.new
  end

  def book_marked
    @feed = Feed.find(params[:feed_id])
    @feed.update(marked: true)
    redirect_to user_feeds_path(current_user)
  end

  def create
    @feed = current_user.feeds.create(params_feed)
    if @feed.errors.messages.empty?
      redirect_to user_feeds_path(current_user)
    else
      flash[:alert] = "Please fill all the fields"
      render 'new'
    end
  end

  def edit;end

  def show;end

  def update
    @feed.update(params_feed)
    if @feed.errors.messages.empty?
      redirect_to user_feed_path(current_user,@feed)
    else
      flash[:alert] = "Please fill all the fields"
      render 'edit'
    end
  end

  def destroy
    @feed.delete
    redirect_to user_feeds_path(current_user)
  end

  def marked_feeds
    @feeds = filter_feeds
    @marked_feeds = []
    @feeds.each do |feed|
      @marked_feeds.push(feed) if feed.marked
    end
  end

  def filter_feeds
    @filter_feeds = []
    @feeds = Feed.all.order(updated_at: :desc)
    @feeds.each do |feed|
      if feed.permission != "friends"
        if feed.permission == "only me"
          @filter_feeds.push(feed) if current_user.id == feed.user_id
        else
          @filter_feeds.push(feed)
        end
      else
        friendship = Friendship.where("user_id = ? AND friend_id = ?", current_user.id, feed.user_id).first
        friendship = Friendship.where("user_id = ? AND friend_id = ?",feed.user_id, current_user.id).first unless friendship
        @filter_feeds.push(feed) if (friendship && friendship.status == "t") || (current_user.id == feed.user_id)
      end
    end

    return @filter_feeds
  end

  private
    def params_feed
      params.require(:feed).permit(:title, :description, :permission)
    end

    def get_feed
      @feed = Feed.find(params[:id])
    end
end
