Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users
  resources :users
  resources :images, only: [:create, :delete] do
    post :remove, on: :member
  end
end
