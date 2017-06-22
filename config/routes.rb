require 'api_constraints'

Rails.application.routes.draw do
  apipie

  devise_for :users

  namespace :api, defaults: {fromat: :json} do
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

    end
  end

end
