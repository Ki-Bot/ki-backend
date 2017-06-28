class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def test_facebook
    render 'test_facebook'
  end
end
