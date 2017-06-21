Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: 'admin/dashboard#index'
  post 'auth' => "auth#authenticate_user"
  devise_for :users

  resources :users, param: :uid do
    resources :locations, only: :index, controller: :points, shallow: true do
      post 'favorite', to: 'points#create'
      delete 'favorite', to: 'points#destroy'
    end
  end
end
