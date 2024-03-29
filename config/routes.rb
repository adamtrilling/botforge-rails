Rails.application.routes.draw do
  root 'dashboard#index'

  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show] do
    member do
      get :confirm
    end
  end
  resources :bots
  resources :games, only: [:index, :show]
  resources :matches, only: [:index, :show, :new, :create]
end
