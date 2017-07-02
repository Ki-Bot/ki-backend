require 'browser'
class Api::V1::Users::SessionsController < Api::ApplicationController
  skip_before_action :authenticate_with_token, only: [:create, :create_fb]

  resource_description do
    resource_id 'authentication'
    short 'Authentication endpoints'
    description 'Endpoints used for user token authentication'
    api_base_url ''
  end

  api! 'Log in'
  param :user, Hash, required: true do
    param :email, String, required: true
    param :password, String, required: true
  end
  formats [:json]
  # POST /resource
  def create
    begin
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
    rescue => e
      render json: {error: e.message}
    end
  end

  # api! 'Log in with Facebook'
  api :GET, "/auth/:provider/callback", "Log in with Facebook and Twitter"
  # api :GET, "/auth/twitter/callback", "Log in with Twitter"
  param :provider, ['facebook', 'twitter'], description: 'Provider of the authentication', required: true
  param :signed_request, String, description: 'authResponse.signed_request returned from facebook login'
  # param :user, Hash, required: true do
  #   param :email, String, required: true
  #   param :password, String, required: true
  # end
  formats [:json]
  def create_fb
    browser = Browser.new(request.user_agent)
    is_mobile = browser.device.mobile?
    @user = User.from_omniauth(request.env["omniauth.auth"])
    @user.generate_authentication_token!
    @user.save
    if !is_mobile && request.env["omniauth.auth"].provider == 'twitter'
      render 'application/twitter'
    else
      render json: user.to_json, status: :ok
    end
  end

  api! 'Log out'
  error :code => 401, desc: 'Unauthorized'
  formats [:json]
  # DELETE /resource
  def destroy
    user = current_user
    user.generate_authentication_token!
    user.oauth_token = ''
    user.save
    head :no_content
  end
end
