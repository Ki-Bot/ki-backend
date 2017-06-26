class Api::V1::BroadbandsController < Api::ApplicationController

  resource_description do
    short 'Broadbands endpoints'
    description 'Endpoints used for searching broadbands'
  end

  api! 'Search broadbands'
  param :q, String, 'Query to search', required: true
  formats [:json]
  def search
    q = params[:q]
    return render json: { error: 'No query was provided!' }, status: :unprocessable_entity if q.blank?
    hits = Broadband.search(q)
    render json: { hits: hits }
  end
end
