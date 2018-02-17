Rails.application.routes.draw do
  root 'athletes#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :activities, only: [:index, :show] do
    member do
      post 'auto_generate_description'
    end

    collection do
      get 'most_kudosed'
    end
  end

  resources :races, only: [:index] do
    member do
      get 'splits'
      get 'efforts'
      get 'preparation'
    end
  end

  resources :athletes, only: [:show, :index]

  namespace :auth do
    get 'exchange', to: 'auth#exchange'
  end
end
