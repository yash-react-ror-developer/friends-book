Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'homes#index'
  resources :feeds, only: [:index]
  resources :users

  get "/contacts/failure", to: "users#friends"
  get "/friends", to: "users#friends", as: "friends"
  get "/contacts/:importer/callback" => "users#friends"
  get "/invite/:id", to: "users#send_invitation", as: "send_invitation"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
