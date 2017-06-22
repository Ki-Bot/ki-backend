class Api::V1::Users::RegistrationsController < Api::ApplicationController
  skip_before_action :authenticate_with_token, only: :create

  # POST /resource
  def create
    user = User.create sign_up_params

    render_updated_resource user do |u|
      sign_in u, store: false
    end
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    user = current_user
    user.update account_update_params

    render_updated_resource user, except: :auth_token do |u|
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in u
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end

  def account_update_params
    params.require(:user).permit(:password, :password_confirmation, :name)
  end
end
