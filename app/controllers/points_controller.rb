class PointsController < ApplicationController
  before_action :authenticate_request!
  before_action :find_user
  before_action :find_point, only: [:create, :destroy]
  filter_access_to :all

  def index
    if @user.present? and @user.favorites.present?
      render json: @user.favorites, each_serializer: PointSerializer
    else
      render nothing: true, status: :not_found
    end
  end

  def create
    if @user.present? and @point.present?
      @user.set_favorite_point(@point)
      render json: @point, serializer: PointSerializer
    else
      render nothing: true, status: :not_found
    end
  end

  def destroy
    if @user.present? and @point.present? and @user.has_favorite?(@point)
      @user.remove_favorite_point(@point)
      render json: @point, serializer: PointSerializer
    else
      render nothing: true, status: :not_found
    end
  end


    private

    def find_user
      @user = User.find user_params[:user_uid]
    end

    def find_point
      @point = get_point(location_params[:location_id])
    end

    def user_params
      params.permit(:user_uid)
    end

    def location_params
      params.permit(:location_id)
    end

    def get_point(location_id)
      Broadband.find location_id
    end

end
