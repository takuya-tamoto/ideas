Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'privacy', to: "toppages#privacy"
  get 'protocol', to: "toppages#protocol"
  
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :create, :edit, :update, :destroy] do
    member do
      get :followings
      get :followers
      get :likes
    end
  end
  resources :posts, only: [:new, :create, :edit, :show, :update, :destroy] do 
    resources :comments, only: [:create]
  end
  resources :relationships, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]
  resources :contacts, only: [:new, :create]
  
end