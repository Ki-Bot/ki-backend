class Api::ApplicationController < ActionController::API
  include Authenticable
  before_action :authenticate_with_token

  respond_to :json
end