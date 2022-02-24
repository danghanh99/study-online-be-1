Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      post '/join', to: 'groups#join'
      post '/login', to: 'users#login'
      post '/out-group', to: 'groups#out_group'
      put '/start', to: 'groups#start'
      put '/close', to: 'groups#close'
      delete '/delete-group', to: 'groups#delete_group'
      resources :users 
      resources :groups
      resources :groups_users

    end
  end
end