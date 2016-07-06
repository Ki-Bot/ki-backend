class UsersController < ApplicationController
  before_action :authenticate_request!
  before_action :find_user, only: [:show]
  filter_access_to :all

  def show
    if @user.present?
      render json: @user
    else
      render nothing: true, status: :not_found
    end
  end

  def create
      @user = User.new
      @user.assign_attributes(user_params[:user])
      if @user.save
        render json: @user
      else
        render nothing: true, status: :bad_request
      end
  end


  private ##################################

  def find_user
    @user = User.find_by(uid: user_get_params[:uid], provider: user_get_params[:provider])
  end

  def user_get_params
    params.permit(:uid, :provider)
  end

  def user_params
    params.permit(user: [:uid, :name, :provider])
  end
end
