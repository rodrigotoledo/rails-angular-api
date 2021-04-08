Rails.application.routes.draw do
  devise_for :users, only: [:sessions], controllers: { sessions: 'api/sessions' }
  namespace :api, defaults: { format: :json } do
    resources :users, only: [:show, :create, :update, :destroy]
    resources :sessions, only: [:create, :destroy]
    resources :tasks
  end
end
