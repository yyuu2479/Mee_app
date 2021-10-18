Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    get 'withdrawal'
    get 'explanation'
    resources :relationships, only: [:create, :destroy]
    get 'relationships/following', as: 'following'
    get 'relationships/follower', as: 'follower'
    get 'relationships/mutual_follow', as: 'mutual_follow'
  end

  resources :posts do
    resources :post_comments, only: [:new, :edit, :create, :destroy, :update]
    resource :likes, only: [:create, :destroy]
  end

  resources :rooms, only: [:show, :create]
  resources :messages, only: [:create]

  resources :notifications, only: [:index, :destroy]

  resources :searchs, only: [:index]

  root 'homes#top'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
