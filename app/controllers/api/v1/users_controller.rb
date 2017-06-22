class Api::V1::UsersController < Api::ApplicationController

  def me
    respond_with current_user
  end

end
