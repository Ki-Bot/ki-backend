require 'api_constraints'

Rails.application.routes.draw do
  root to: "home#index"

  devise_for :users

  namespace :api, defaults: {fromat: :json} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      scope module: :users do
        post 'users/login', to: 'sessions#create'
        delete 'users/logout', to: 'sessions#destroy'
      end
    end
  end

end
