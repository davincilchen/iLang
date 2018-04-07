Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: "registrations"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # root "users#index"
  root "users#landing"
 
  resources :lessons, only: [:index, :new, :create, :show, :update] do
    collection do
      get :update_languages
    end
  end

  resources :users, only: [:show, :edit, :update, :create, :destroy] do

    collection do
      get :search
    end

    member do 
      patch :learning
      patch :teaching
      get :new_lesson
    end

  end

  get '/home', to: 'users#home', as: 'home'

  resources :friendships, only: [:create, :destroy]

  resources :vocabs do
    collection do
      get :search_vocabs
    end
  end

  resources :reviews, only: [:index]
end
