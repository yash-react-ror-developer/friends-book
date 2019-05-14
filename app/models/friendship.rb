class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User', optional: true

  def Friendship.get_friends(user)
    friends = []
    accepted_sent_requests = user.friendships.where(status: true)
    accepted_received_requests = user.inverse_friendships.where(status: true)
    accepted_sent_requests.each do |request|
      friends.push(User.find(request.friend_id))
    end
    accepted_received_requests.each do |request|
      friends.push(User.find(request.user_id))
    end
    friends
  end
end
