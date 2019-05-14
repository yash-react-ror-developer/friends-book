class Feed < ApplicationRecord
  validates :title, :description, presence: true
  belongs_to :user
  #belongs_to :userbookmark

  def Feed.user_feeds(user)
    filter_feeds = []
    feeds = Feed.all.order(updated_at: :desc)
    feeds.each do |feed|
      if feed.permission != "friends"
        if feed.permission == "only me"
          filter_feeds.push(feed) if current_user.id == feed.user_id
        else
          filter_feeds.push(feed)
        end
      else
        if user.friendships.where(friend_id: feed.user_id, status: true).first || user.friendships.where(user_id: feed.user_id, status: true).first
          filter_feeds.push(feed)
        else
          filter_feeds.push(feed) if user.id == feed.user_id
        end
      end
    end
    filter_feeds
  end
end
