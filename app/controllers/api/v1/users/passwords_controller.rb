class Api::V1::Users::PasswordsController < Api::ApplicationController
  skip_before_action :authenticate_with_token

  resource_description do
    short 'Passwords endpoints'
    description 'Endpoints used for user passwords reset'
  end

  api! 'Request password reset token'
  param :user, Hash, required: true do
    param :email, String, 'Users email address', required: true
  end
  formats [:json]
  # POST /resource/password
  def create
    user = User.send_reset_password_instructions reset_params

    respond_with user, :location => root_path
  end

  api :PATCH, '/users/password', 'Update the password using reset password token'
  api :PUT, '/users/password', 'Update the password using reset password token'
  error code: 422, desc: 'Unprocessable entity'
  param :user, Hash, required: true do
    param :reset_password_token, String, required: true
    param :password, String, required: true
    param :password_confirmation, String, required: true
  end
  formats [:json]
  # PUT /resource/password
  def update
    user = User.reset_password_by_token update_password_params

    if user.errors.empty?
      user.unlock_access! if unlockable?(user)
      if Devise.sign_in_after_reset_password
        sign_in user, store: false
        respond_with user, location: root_path
      else
        head :ok, :location => root_path
      end
    else
      render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  protected

  def reset_params
    params.require(:user).permit(:email)
  end

  def update_password_params
    params.require(:user).permit(:reset_password_token, :password, :password_confirmation)
  end

  def unlockable?(resource)
    resource.respond_to?(:unlock_access!) &&
        resource.respond_to?(:unlock_strategy_enabled?) &&
        resource.unlock_strategy_enabled?(:email)
  end

end
