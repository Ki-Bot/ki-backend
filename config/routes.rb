require 'api_constraints'

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  apipie

  devise_for :users

  root to: 'admin/dashboard#index'
  get 'test_facebook', to: 'application#test_facebook'

  match 'auth/:provider/callback', to: 'api/v1/users/sessions#create_fb', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  # match 'signout', to: 'api/v1/users/sessions#destroy', via: [:get, :post]

  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do

      namespace :users do

        post '/', to: 'registrations#create'
        match '/', to: 'registrations#update', via: [:patch, :put]

        post 'password', to: 'passwords#create'
        match 'password', to: 'passwords#update', via: [:patch, :put]

        post 'login', to: 'sessions#create'
        delete 'logout', to: 'sessions#destroy'
      end

      get 'users/me', to: 'users#me'

      resources :points, only: [:index, :create, :destroy]
      resources :broadbands, only: [:show, :create, :update] do
        collection do
          get 'search', to: 'broadbands#search'
        end
      end
    end
  end

end
