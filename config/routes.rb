Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users
  resources :users
  resources :images, only: [:create, :destroy] do
    post :remove, :unremove, :share, :effect, on: :member
    get :versions, on: :member
    get :removed, on: :collection
  end
end
