class Api::V1::PointsController < Api::ApplicationController
  before_action :get_point, only: [:create, :destroy]

  resource_description do
    short 'User points endpoints'
    description 'Endpoints used for showing, adding and removing user\'s points'
  end

  api! 'Show logged-in user\'s favorite points'
  formats [:json]
  def index
    render json: current_user.favorites
  end

  api! 'Add new favorite point for the logged-in user'
  param :id, String, 'Broadband\'s id', required: true
  formats [:json]
  def create
    if @point.present?
      current_user.set_favorite_point!(@point)
      render json: { success: true }
    else
      render json: { error: 'The broadband was not found' }
    end
  end

  api! 'Remove the specified point from the logged-in user\'s favorite points'
  param :id, String, 'Broadband\'s id', required: true
  formats [:json]
  def destroy
    if @point.present? && current_user.has_favorite?(@point)
      current_user.remove_favorite_point!(@point)
      render json: { success: true }
    else
      render json: { error: 'The broadband was not found' }
    end
  end

  private

  def get_point
    @point = Broadband.find_by_id(params[:id])
  end

end
