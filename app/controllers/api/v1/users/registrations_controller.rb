class Api::V1::Users::RegistrationsController < Api::ApplicationController
  skip_before_action :authenticate_with_token, only: :create

  resource_description do
    name 'Registration'
    short 'Registration endpoints'
    description 'Endpoints used for user registration'
  end

  def_param_group :user do
    param :name, String, 'Name of the user'
    param :password, String, required: true
    param :password_confirmation, String, required: true
  end

  def_param_group :user_signup do
    param :user, Hash, required: true, action_aware: true do
      param :email, String, required: true
      param_group :user
    end
  end

  def_param_group :user_update do
    param :user, Hash, required: true, action_aware: true do
      param_group :user
    end
  end

  api! 'Sign up'
  param_group :user_signup
  formats [:json]
  # POST /resource
  def create
    user = User.create sign_up_params

    render_updated_resource user do |u|
      sign_in u, store: false
    end
  end

  api :PATCH, '/users', 'Update currently authenticated user'
  api :PUT, '/users', 'Update currently authenticated user'
  error code: 401, desc: 'Unauthorized'
  param_group :user_update
  formats [:json]
  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    user = current_user
    user.update update_params

    render_updated_resource user, except: :auth_token do |u|
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in u
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end

  def update_params
    params.require(:user).permit(:password, :password_confirmation, :name)
  end
end