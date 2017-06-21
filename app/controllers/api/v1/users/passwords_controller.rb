class Api::V1::Users::PasswordsController < ActionController::Base
  respond_to :json

  # POST /resource/password
  def create
    user = User.send_reset_password_instructions reset_params

    respond_with user_json(user), :location => root_path
  end

  # PUT /resource/password
  def update
    user = User.reset_password_by_token update_password_params

    if user.errors.empty?
      user.unlock_access! if unlockable?(user)
      if Devise.sign_in_after_reset_password
        sign_in user, store: false
        respond_with user, location: root_path
      else
        head 200, :location => root_path
      end
    else
      render json: {errors: user.errors.full_messages}, status: 422
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
