Rails.application.routes.draw do
  root 'activities#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :activities do
    collection do
      get 'israman_splits'
      get 'israman_efforts'
    end
  end

  namespace :auth do
    get 'exchange', to: 'auth#exchange'
  end
end
