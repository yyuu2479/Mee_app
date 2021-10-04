Rails.application.routes.draw do
  devise_for :users

  resources :users, only:[:index, :show, :edit, :update] do
    resources :relationships, only:[:create, :destroy]
    get 'relationships/following', as: 'following'
    get 'relationships/follower', as: 'follower'
    get 'relationships/mutual_follow', as: 'mutual_follow'
  end


  resources :posts do
    resources :post_comments, only:[:new, :edit, :create, :destroy, :update]
    resource :likes, only:[:create, :destroy]
  end

  resources :rooms, only:[:show, :create]
  resources :messages, only:[:create]

  resources :notifications, only:[:index]

  resources :searchs, only:[:index]

  root 'homes#top'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
