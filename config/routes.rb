Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  namespace :api do
    resources :users, param: :_username
    post '/auth/login', to: 'api/authentication#login'
    get '/*a', to: 'api/application#not_found'
  end
end
