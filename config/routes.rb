Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'homes#index'

  resources :users do
    resources :feeds do
      patch 'book_marked'
    end
  end

  get 'search_user', to: "users#search_user"
  get 'invited_friends', to: "users#invited_friends"

  get 'marked_feeds', to: "feeds#marked_feeds"

  post 'send_request', to: "users#send_request", as: "send_request"

  delete 'cancel_request/:id', to: "users#cancel_request", as: "cancel_request"

  patch 'accept_user/:id', to: "users#accept_user", as: "accept_user"

  get 'friend_list', to: "users#friend_list", as: "friend_list"

  get "/contacts/failure", to: "users#friends"
  get "/friends", to: "users#friends", as: "friends"
  get "/contacts/:importer/callback" => "users#friends"
  get "/invite/:id", to: "users#send_invitation", as: "send_invitation"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
