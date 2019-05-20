Rails.application.routes.draw do
  get 'home/index'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root to: "home#index"


  resources :users do
    collection do
      get 'view_profile', to: "users#view_profile", as: "view_profile"
    end
  end

  resources :feeds do
    patch 'book_marked'
  end


  post 'send_request/:id', to: "friend_ships#send_request", as: "send_request"

  get 'invited_users', to: "friend_ships#invited_users", as: "invited_users"

  delete 'cancel_request/:id', to: "friend_ships#cancel_request", as: "cancel_request"

  patch 'accept_user/:id', to: "friend_ships#accept_user", as: "accept_user"

  get 'friend_list', to: "friend_ships#friend_list", as: "friend_list"

  get 'search_user', to: "users#search_user"

  get 'marked_feeds', to: "feeds#marked_feeds"

  get "/contacts/failure", to: "friend_ships#friends"
  get "/invite_friends", to: "friend_ships#invite_friends", as: "friends"
  get "/contacts/:importer/callback" => "friend_ships#invite_friends"
  get "/send_invitation/:id", to: "friend_ships#send_invitation", as: "send_invitation"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  match '*unmatched_route', :to => 'application#raise_not_found', :via => :all
end
