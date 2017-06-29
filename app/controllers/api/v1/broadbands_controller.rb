class Api::V1::BroadbandsController < Api::ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  skip_before_action :authenticate_with_token, only: [:search, :show]
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
    request_params = broadband_params
    request_params[:logo] = process_base64(broadband_params[:logo])
    request_params[:banner] = process_base64(broadband_params[:banner])
    @broadband = Broadband.new(request_params)
    if @broadband.save!
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
    request_params = broadband_params
    request_params[:logo] = process_base64(broadband_params[:logo])
    request_params[:banner] = process_base64(broadband_params[:banner])
    if @broadband.update!(request_params)
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
      params.require(:broadband).permit(:anchorname, :address, :bldgnbr, :predir, :suffdir, :streetname, :streettype, :city, :state_code, :zip5, :latitude, :longitude, :publicwifi, :url, :banner, logo: [:data, :filename], banner: [:data, :filename], opening_hours_attributes: [:id, :day, :from, :to, :open])
  end

  def process_base64(string_info)
    if string_info
      image = Paperclip.io_adapters.for(string_info[:data])
      image.original_filename = string_info[:filename]
      image
      # data = StringIO.new(Base64.decode64(string_info[:data]))
      # data.class.class_eval { attr_accessor :original_filename, :content_type }
      # data.original_filename = string_info[:filename]
      # data.content_type = string_info[:content_type]
      # data
    end
  end

  def record_not_found
    render json: { error: 'Record not found!' }, status: :unprocessable_entity
  end
end
