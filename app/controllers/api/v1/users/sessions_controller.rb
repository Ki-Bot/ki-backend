class Api::V1::Users::SessionsController < Api::ApplicationController
  skip_before_action :authenticate_with_token, only: [:create]

  def create
    user_password = params[:user][:password]
    user_email = params[:user][:email]
    user = user_email.present? && User.find_by(email: user_email)

    if user&.valid_password?(user_password)
      sign_in :user, user, store: false
      user.generate_authentication_token!
      user.save
      render json: user.to_json, status: :ok
    else
      render json: {errors: 'Invalid email or password'}, status: :unprocessable_entity
    end
  end

  def destroy
    user = current_user
    user.generate_authentication_token!
    user.save
    head :no_content
  end
end
