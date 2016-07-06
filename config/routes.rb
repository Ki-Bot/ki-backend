Rails.application.routes.draw do

  post 'auth' => "auth#authenticate_user"

  resources :users, param: :uid
end
