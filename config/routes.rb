require 'api_constraints'

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  apipie

  devise_for :users

  get 'organizations/:id/activate', to: 'organizations#activate'
  get 'organizations/:id/approved', to: 'organizations#approved'

  root to: 'admin/dashboard#index'
  get 'test_facebook', to: 'application#test_facebook'
  get 'social_login', to: 'application#social_login'

  match 'auth/:provider/callback', to: 'api/v1/users/sessions#create_social', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  # match 'signout', to: 'api/v1/users/sessions#destroy', via: [:get, :post]

  get 'api/auth/facebook/mobile_callback', to: 'api/v1/users/sessions#create_fb_mobile', via: [:get, :post]
  get 'api/auth/twitter/mobile_callback', to: 'api/v1/users/sessions#create_twitter_mobile', via: [:get, :post]

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
          get 'search_by_location', to: 'broadbands#search_by_location'
          get 'filter', to: 'broadbands#filter'
          get 'search_all', to: 'broadbands#search_all'
          get 'types', to: 'broadbands#types'
          # get 'acquire/:id', to: 'broadbands#acquire'
          get 'my_broadbands', to: 'broadbands#my_broadbands'
        end
      end

      resources :organizations, only: [:create]

    end
  end

end