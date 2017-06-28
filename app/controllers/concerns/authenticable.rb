module Authenticable

  # Devise methods overwrites
  def current_user
    # regular auth method
    @current_user ||= User.find_by(auth_token: request.headers['Authorization']) if request.headers['Authorization'].present?

    @current_user ||= User.find_by(oauth_token: request.headers['Authorization']) if request.headers['Authorization'].present?

    # impersonating users
    # check if session is defined to let authenticable tests pass since session is not available there
    @current_user ||= User.find_by(auth_token: session['Authorization']) if defined? session && session['Authorization'].present?

    @current_user
  end

  def authenticate_with_token
    render json: { error: 'Not authenticated' }, status: :unauthorized unless user_signed_in?
  end

  def user_signed_in?
    current_user.present?
  end

end
