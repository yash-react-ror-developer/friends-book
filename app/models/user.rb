class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  has_many :friendships
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: 'friend_id'
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  has_many :feeds
  has_many :userbookmarks
  has_many :bookmarks, through: :userbookmarks, source: :feed
  has_many :contacts, dependent: :destroy
  has_one_attached :avatar

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.find_by(email: data['email'])
    unless user
      user = User.create(email: data['email'], first_name: data['first_name'] || data['name'].split(" ")[0], last_name: data['last_name']  || data['name'].split(" ")[1], password: Devise.friendly_token[0,20])
    end
    user
  end
end
