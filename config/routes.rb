Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: "registrations"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "users#index"

  resources :lessons, only: [:index, :new, :create, :destroy] 

  resources :users, only: [:index, :show, :edit, :update, :create, :destroy] do

    resources :lessons, only: [:index] do
     
    end

    collection do
      get :search
    end

    member do 
      patch :learning
      patch :teaching
    end

  end

  resources :friendships, only: [:create, :destroy]

  get 'lessons/ui'

end
