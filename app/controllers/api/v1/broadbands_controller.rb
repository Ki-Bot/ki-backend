class Api::V1::BroadbandsController < Api::ApplicationController
  before_action :set_broadband, only: [:show, :update]

  resource_description do
    short 'Broadbands endpoints'
    description 'Endpoints used for searching broadbands'
  end

  def_param_group :broadband_params do
    param :broadband, Hash, required: true do
      param :anchorname, String, 'Name of the anchor'
      param :address, String
      param :bldgnbr, String
      param :predir, String
      param :suffdir, String
      param :streetname, String
      param :streettype, String
      param :city, String
      param :state_code, String
      param :zip5, String
      param :latitude, BigDecimal
      param :longitude, BigDecimal
      param :publicwifi, String
      param :url, String
    end
  end

  api! 'Search broadbands'
  param :q, String, 'Query to search', required: true
  formats [:json]
  def search
    q = params[:q]
    return render json: { error: 'No query was provided!' }, status: :unprocessable_entity if q.blank?
    hits = Broadband.search(q)
    render json: hits, each_serializer: BroadbandSerializer
  end

  api! 'Broadband details'
  param :id, Integer, 'Broadband id', required: true
  formats [:json]
  def show
    render json: @broadband
  end

  api! 'Create Broadband'
  param_group :broadband_params
  formats [:json]
  def create
    @broadband = Broadband.new(broadband_params)
    if @broadband.save
      render json: @broadband
    else
      render json: @broadband.errors, status: :unprocessable_entity
    end
  end

  api! 'Update Broadband'
  param :id, Integer, 'Broadband id', required: true
  param_group :broadband_params
  formats [:json]
  def update
    if @broadband.update(broadband_params)
      render json: @broadband
    else
      render json: @broadband.errors, status: :unprocessable_entity
    end
  end

  private

  def set_broadband
    @broadband = Broadband.find(params[:id])
  end

  def broadband_params
      params.require(:broadband).permit(:anchorname, :address, :bldgnbr, :predir, :suffdir, :streetname, :streettype, :city, :state_code, :zip5, :latitude, :longitude, :publicwifi, :url)
  end
end
