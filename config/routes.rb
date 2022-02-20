Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      post '/join', to: 'groups#join'
      post '/login', to: 'users#login'
      resources :users 
      resources :groups
      resources :groups_users

    end
  end
end