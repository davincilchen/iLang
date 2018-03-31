Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: "registrations"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "users#index"

  resources :lessons, only: [:index, :new, :create, :show, :update] do
    collection do
      get :update_languages
    end
  end
  resources :users, only: [:index, :show, :edit, :update, :create, :destroy] do

    collection do
      get :search
    end

    member do 
      patch :learning
      patch :teaching
      get :lessons
    end

  end

  resources :friendships, only: [:create, :destroy]


end
