Rails.application.routes.draw do
  authenticated :user do
    root 'users#home', as: :authenticated_root
  end
  get 'home', to: 'users#home'
  put 'home', to: 'users#home'
  get 'about', to: 'users#about'

  root to: "users#index"

  devise_for :users, :controllers => { registrations: 'registrations', :omniauth_callbacks => "omniauth_callbacks" }

  resources :suggestions

  resources :quick_events

  get 'alertas', to: 'quick_events#index'

  resources :events do
    member do
      get 'add_participant'
      get 'remove_participant'
      get 'successful'
    end
  end
end
