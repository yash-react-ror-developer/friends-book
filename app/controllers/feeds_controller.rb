class FeedsController < ApplicationController
  before_action :get_feed, only: [:edit, :update, :show, :destroy]

  def index
    @feeds = current_user.feeds
  end

  def new
    @feed = current_user.feeds.new
  end

  def book_marked
    @feed = Feed.find(params[:feed_id])
    @feed.update(marked: true)
    @feeds = current_user.feeds
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
    @feeds = current_user.feeds.paginate(page: params[:page], per_page: 10).where(marked: true)
  end

  private
    def params_feed
      params.require(:feed).permit(:title, :description)
    end

    def get_feed
      @feed = Feed.find(params[:id])
    end
end
