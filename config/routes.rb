Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: "registrations"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "users#index"

  resources :lessons, only: [:new, :create, :destroy] 

  resources :users do

    collection do
      get :search
    end

  end
  
  resources :languages, only: [:index] 
end
