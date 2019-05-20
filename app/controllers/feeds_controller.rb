class FeedsController < ApplicationController
  before_action :get_feed, only: [:edit, :update, :show, :destroy]
  before_action :authenticate_user!

  def index
    @filter_feeds = Feed.user_feeds(current_user).paginate(page: params[:page], per_page: 12)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @feed = current_user.feeds.new
  end

  def book_marked
    bookmark = current_user.userbookmarks.create(feed_id: params[:feed_id])
    if bookmark
      flash[:notice] = "marked successfully"
    else
      flash[:alert] = "something went wrong"
    end
    @feed = Feed.find(params[:feed_id])
  end

  def create
    @feed = current_user.feeds.create(params_feed)
    if @feed.errors.messages.empty?
      redirect_to feeds_path
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
    if @feed.delete
      flash[:notice] = "Feed deleted successfully"
    else
      flash[:alert] = "something went wrong"
    end
    redirect_to feeds_path
  end

  def marked_feeds
    @marked_feeds = current_user.bookmarks.paginate(page: params[:page], per_page: 10)
  end



  private
    def params_feed
      params.require(:feed).permit(:title, :description, :permission)
    end

    def get_feed
      @feed = Feed.find(params[:id])
    end
end
