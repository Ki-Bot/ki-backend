Rails.application.routes.draw do

  devise_for :users

  resources :users, param: :uid do
    resources :locations, only: :index, controller: :points, shallow: true do
      post 'favorite', to: 'points#create'
      delete 'favorite', to: 'points#destroy'
    end
  end
end
