class Api::V1::UsersController < Api::ApplicationController

  api!
  def me
    respond_with current_user
  end

end
