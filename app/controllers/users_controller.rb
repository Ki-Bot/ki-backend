class UsersController < ApplicationController
  before_action :authenticate_request!
  filter_access_to :all

  def create
      @user = User.new
      Rails.logger.debug user_params
      @user.assign_attributes(user_params[:user])
      if @user.save
        render json: @user
      else
        render nothing: true, status: :bad_request
      end
  end


  private ##################################

  def find_user
    @user = User.find_by(uid: user_params[:uid], provider: user_params[:provider])
  end

  def user_params
    params.permit(user: [:uid, :name, :provider])
  end
end
