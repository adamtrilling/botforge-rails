Rails.application.routes.draw do
  root 'dashboard#index'
  resource :session, only: [:new, :create, :destroy]
end
