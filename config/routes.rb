Rails.application.routes.draw do
  root 'activities#index'
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

  namespace :auth do
    get 'exchange', to: 'auth#exchange'
  end
end
