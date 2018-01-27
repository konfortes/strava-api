Rails.application.routes.draw do
  root 'activities#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :activities do
    member do
      post 'auto_generate_description'
    end

    collection do
      get 'israman_splits'
      get 'israman_efforts'
      get 'israman_preparation'
      get 'most_kudosed'
    end
  end

  namespace :auth do
    get 'exchange', to: 'auth#exchange'
  end
end
