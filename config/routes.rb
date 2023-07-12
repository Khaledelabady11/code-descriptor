Rails.application.routes.draw do
  
  namespace :api do
    resources :posts
  end

  namespace :api do
    resources :users, param: :_username
    post '/auth/login', to: 'authentication#login'
    get '/*a', to: 'application#not_found'
  end


end
