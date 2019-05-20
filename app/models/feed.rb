class Feed < ApplicationRecord
  validates :title, :description, presence: true
  belongs_to :user
  #belongs_to :userbookmark

  def self.user_feeds(user)
    if(user)
      friend_ids = user.friendships.where(status: true).map(&:friend_id) + user.inverse_friendships.where(status: true).map(&:user_id) + [user.id]
      filter_feeds =  Feed.where(permission: "public").or(Feed.where("permission = ? AND user_id = ?", "only me", user.id)).or(Feed.where(permission: "friends", user_id: friend_ids))
    end
  end
end