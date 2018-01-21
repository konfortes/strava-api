Rails.application.routes.draw do
  root 'activities#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :activities

  namespace :auth do
    get 'exchange', to: 'auth#exchange'
  end
end
