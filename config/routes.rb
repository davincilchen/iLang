Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "users#index"

  resources :lessons, only: [:new, :create, :destroy] 

  resources :users, only: [:index, :create, :destroy]
  
  resources :teachings, only: [:index, :create, :destroy]
end
