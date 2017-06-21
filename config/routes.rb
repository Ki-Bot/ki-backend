Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: 'admin/dashboard#index'
  post 'auth' => "auth#authenticate_user"

  resources :users, param: :uid do
    resources :locations, only: :index, controller: 'points' do
      match 'favorite', to: 'points#create', via: [:post]
      match 'favorite', to: 'points#destroy', via: [:delete]
    end
  end


end
