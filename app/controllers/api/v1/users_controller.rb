class Api::V1::UsersController < Api::ApplicationController

  def me
    respond_with user_json current_user
  end

end
