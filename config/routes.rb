Rails.application.routes.draw do
  root 'activities#index'
  devise_for :users, controllers: { omniauth_callbacks: 'callbacks' }

  resources :activities, only: %I[index show] do
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

  resources :athletes, only: %I[show index]

  post '/webhooks', to: 'webhooks#hook'
  get '/webhooks', to: 'webhooks#verify'
end
