Rails.application.routes.draw do
  devise_for :users, only: [:sessions], controllers: { sessions: 'api/sessions' }
  namespace :api, defaults: { format: :json } do
    mount_devise_token_auth_for 'User', at: 'auth'
    resources :users, only: [:show, :create, :update, :destroy]
    resources :tasks
    resources :sessions, only: [:create, :destroy]
  end
end
