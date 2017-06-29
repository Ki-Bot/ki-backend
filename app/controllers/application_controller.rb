class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_action :allow_iframe, only: :test_facebook

  def test_facebook
    render 'test_facebook'
  end

  private

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end
end
