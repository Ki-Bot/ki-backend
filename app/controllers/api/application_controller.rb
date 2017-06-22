class Api::ApplicationController < ActionController::API
  include Authenticable
  before_action :authenticate_with_token

  respond_to :json

  private

  def render_resource_errors(resource)
    render json: {errors: resource.errors.full_messages}, status: :unprocessable_entity if resource.errors.any?
  end

  def render_updated_resource(resource, except = nil)
    if resource.errors.empty?
      yield resource if block_given?
      render json: resource.as_json(except)
    else
      render_resource_errors resource
    end
  end
end