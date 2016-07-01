Rails.application.routes.draw do

  post 'auth' => "auth#authenticate_user"

  resources :users
end
