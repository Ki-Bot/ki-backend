class Api::V1::UsersController < Api::ApplicationController

  api! 'Get information about currently signed in user'
  def me
    respond_with current_user
  end

end
