class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_action :allow_iframe, only: :social_login

  def test_facebook
    render 'test_facebook'
  end

  def social_login
    render 'social_login', layout: false
  end

  private

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end
end
