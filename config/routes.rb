Rails.application.routes.draw do
  authenticated :user do
    root 'users#home', as: :authenticated_root
  end

  root to: "users#index"

  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :suggestions

  resources :events do
    member do
      get 'add_participant'
      get 'remove_participant'
    end
  end
end
