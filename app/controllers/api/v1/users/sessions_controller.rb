require 'browser'
class Api::V1::Users::SessionsController < Api::ApplicationController
  skip_before_action :authenticate_with_token, only: [:create, :create_social, :create_fb_mobile, :create_twitter_mobile]

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
  api :GET, "/auth/:provider/callback", "Log in with Facebook and Twitter - Web callback endpoint"
  param :provider, ['facebook', 'twitter'], description: 'Provider of the authentication', required: true
  param :signed_request, String, description: 'authResponse.signed_request returned from facebook login'
  formats [:json]
  def create_social
    browser = Browser.new(request.user_agent)
    is_mobile = browser.device.mobile?
    @user = User.from_omniauth(request.env["omniauth.auth"])
    @user.generate_authentication_token!
    if request.env["omniauth.auth"].key?('info')
      @user.name = request.env["omniauth.auth"]['info']['name'] if request.env["omniauth.auth"]['info'].key?('name')
      @user.profile_picture = request.env["omniauth.auth"]['info']['image'] if request.env["omniauth.auth"]['info'].key?('image')
    end
    @user.save!
    if !is_mobile && request.env["omniauth.auth"].provider == 'twitter'
      render 'application/twitter'
    else
      render json: user.to_json, status: :ok
    end
  end

  api :GET, "/api/auth/facebook/mobile_callback", "Log in with Facebook - Mobile callback endpoint"
  param :token, String, description: 'access_token returned by facebook login'
  param :uid, String, description: 'user id returned by facebook login'
  formats [:json]
  def create_fb_mobile
    token = params[:token]
    uid = params[:uid]
    @graph = Koala::Facebook::API.new(ENV['facebook_app_access_token'])
    response = @graph.debug_token(token)
    if response.present? && response['data'].present?
      app_id = response['data']['app_id']
      user_id = response['data']['user_id']
      if app_id == ENV['facebook_app_id'] && user_id == uid
        res = @graph.get_object(user_id, fields: ['name', 'email', 'picture.type(large)'])
        picture = nil
        picture = res['picture']['data']['url'] if res.key?('picture') && res['picture'].key?('data')
        user = User.custom_oauth('facebook', user_id, token, res['email'], res['name'], picture)
        user.generate_authentication_token!
        user.email = res['email']
        user.name = res['name']
        user.profile_picture = picture
        user.save!
        return render json: { id: user.id, auth_token: user.auth_token }
      end
    end
    head :unauthorized
  end

  api :GET, "/api/auth/twitter/mobile_callback", "Log in with Twitter - Mobile callback endpoint"
  param :token, String, description: 'access_token'
  param :secret, String, description: 'secret token'
  param :uid, String, description: 'user id'
  formats [:json]
  def create_twitter_mobile
    token = params[:token]
    secret = params[:secret]
    uid = params[:uid]
    res = nil
    begin
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['twitter_app_id']
        config.consumer_secret     = ENV['twitter_secret']
        config.access_token        = token
        config.access_token_secret = secret
      end
      res = client.verify_credentials
    rescue
    end
    if res.present? && res[:id].to_s == uid
      user = User.custom_oauth('twitter', uid, token, nil, res['name'], res['profile_image_url_https'])
      user.generate_authentication_token!
      user.name = res['name']
      user.profile_picture = res['profile_image_url_https']
      user.save!
      render json: { id: user.id, auth_token: user.auth_token }
    else
      head :unauthorized
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
