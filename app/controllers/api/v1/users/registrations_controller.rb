class Api::V1::Users::RegistrationsController < Api::ApplicationController
  skip_before_action :authenticate_with_token, only: :create

  def_param_group :user do
    param :name, String, 'Name of the user'
    param :password, String, 'Password', required: true
    param :password_confirmation, String, 'Password confirmation', required: true
  end

  def_param_group :user_signup do
    param :user, Hash, required: true, action_aware: true do
      param :email, String, 'Users email address', required: true
      param_group :user
    end
  end

  def_param_group :user_update do
    param :user, Hash, required: true, action_aware: true do
      param_group :user
    end
  end

  api!
  param_group :user_signup
  # POST /resource
  def create
    user = User.create sign_up_params

    render_updated_resource user do |u|
      sign_in u, store: false
    end
  end

  api :PATCH, '/users'
  api :PUT, '/users'
  error :code => 401, desc: 'Unauthorized'
  param_group :user_update
  description 'Update the user'
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
