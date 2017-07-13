class Api::V1::BroadbandsController < Api::ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  skip_before_action :authenticate_with_token, only: [:search, :filter, :show, :types, :search_by_location, :search_all]
  before_action :set_broadband, only: [:show, :update, :acquire]

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
      param :opening_hours_attributes, Array, of: Hash do
        param :day, [1, 2, 3, 4, 5, 6, 7]
        param :from, String, desc: 'Time format: hh:MM:ss'
        param :to, String, desc: 'Time format: hh:MM:ss'
        param :closed, [true, false]
      end
      param :logo, Hash, required: false do
        param :data, String, desc: 'Image content as Base64 string'
        param :filename, String, desc: 'Name of the logo file'
      end
      param :banner, Hash, required: false do
        param :data, String, desc: 'Image content as Base64 string'
        param :filename, String, desc: 'Name of the banner file'
      end
    end
  end

  api! 'Search broadbands'
  param :q, String, 'Query to search.', required: true
  formats [:json]
  def search
    q = params[:q]
    offset = params[:offset]
    length = params[:length]
    return render json: { error: 'No query was provided!' }, status: :unprocessable_entity if q.blank?
    hits = Broadband.search(q, offset, length)
    render json: hits, each_serializer: SimpleBroadbandSerializer
  end

  api! 'Sort by distance to a central location. Add the location to a custom HTTP header called "user_location". Location format: "{latitude},{longitude}".'
  param :types, String, 'Organization types', required: false
  param :radius, Integer, 'Radius in Meters', required: false
  formats [:json]
  def search_by_location
    location = request.headers['HTTP_USER_LOCATION']
    radius = params[:radius]
    types = params[:types]
    hits = Broadband.search_by_location(location, radius, types, current_user)
    render json: hits #, each_serializer: SimpleBroadbandSerializer
  end

  api! 'Filter broadband results by type'
  param :q, String, 'Search query', required: true
  param :types, String, 'Organization types', required: true
  param :offset, Integer, 'Pagination Offset', default: 0
  param :length, Integer, 'Pagination Length (Limit)', default: 500
  formats [:json]
  def filter
    q = params[:q]
    types = params[:types]
    offset = params[:offset]
    length = params[:length]
    if q.blank? || types.blank?
      return render json: { error: 'No ' + (q.blank? ? 'query' : 'type') + ' was provided!' }, status: :unprocessable_entity
    end
    hits = Broadband.filter(q, types, offset, length)
    render json: hits, each_serializer: SimpleBroadbandSerializer
  end

  api! 'Search, filter, or search by location. To search by location add the location to a custom HTTP header called "user_location". Location format: "{latitude},{longitude}".'
  param :q, String, 'Search query', required: true
  param :types, String, 'Organization types', required: true
  param :offset, Integer, 'Pagination Offset', default: 0
  param :length, Integer, 'Pagination Length (Limit)', default: 500
  param :radius, Integer, 'Radius in Meters', required: false
  formats [:json]
  def search_all
    q = params[:q]
    types = params[:types]
    offset = params[:offset]
    length = params[:length]
    radius = params[:radius]
    location = request.headers['HTTP_USER_LOCATION']
    hits = Broadband.search_all(q, types, location, offset, length, radius, current_user)
    render json: hits#, each_serializer: SimpleBroadbandSerializer
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
    res = false
    # Broadband.without_auto_index do
      res = @broadband.save!
    # end

    if res
      current_user.broadbands << @broadband
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
    if current_user.can_edit_broadband(@broadband)
      request_params = broadband_params
      request_params[:logo] = process_base64(request_params[:logo]) if request_params.key?(:logo)
      request_params[:banner] = process_base64(request_params[:banner]) if request_params.key?(:banner)
      res = false
      # Broadband.without_auto_index do
        res = @broadband.update!(request_params)
      # end
      if res
        render json: @broadband
      else
        render json: @broadband.errors, status: :unprocessable_entity
      end
    else
      render json: '', status: :unauthorized
    end
  end

  api! 'Broadband Types'
  formats [:json]
  def types
    render json: BroadbandType.select(:id, :name)
  end

  def acquire
    if @broadband.present?
      current_user.broadbands << @broadband unless current_user.broadbands.include?(@broadband)
      return render json: { success: true }
    end
    render json: { error: 'Broadband not found!' }
  end

  def my_broadbands
    render json: { my_broadbands: current_user.broadbands }
  end


  private

  def set_broadband
    @broadband = Broadband.find(params[:id])
  end

  def broadband_params
      params.require(:broadband).permit(:anchorname, :address, :bldgnbr, :predir, :suffdir, :streetname, :streettype, :city, :state_code, :zip5, :latitude, :longitude, :publicwifi, :url, :broadband_type_id, :services, logo: [:data, :filename], banner: [:data, :filename], opening_hours_attributes: [:id, :day, :from, :to, :closed])
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
