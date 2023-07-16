Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    resources :posts do
      collection do
        get 'myposts'
      end
       resources :likes, only: [:index]
    end
  end
  namespace :api do
    get '/articles/:post_id', to: 'articles#show'
  end
  namespace :api do
    resources :likes, only: [:create, :destroy]
  end

  namespace :api do
    resources :users, param: :_username
    post '/auth/login', to: 'authentication#login'
  end
end
