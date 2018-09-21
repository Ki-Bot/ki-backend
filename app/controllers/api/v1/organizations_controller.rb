class Api::V1::OrganizationsController < Api::ApplicationController
  skip_before_action :authenticate_with_token, only: :create

  def_param_group :organization do
    param :name, String, 'Name of the organization'
    param :email, String, required: true
    param :password, String, required: true
    param :manager_name, String, required: true
    param :phone_no, String, required: true
    param :address, String, required: true
  end

  # def_param_group :user do
  #   param :name, String, 'Name of the organization'
  #   param :email, String, required: true
  #   param :password, String, required: true
  #   param :phone_no, String, required: true
  #   param :profile_picture, String, required: true
  # end

  api! 'Create Organization'
  param_group :organization
  formats [:json]
  # POST /resource
  def create
    user = User.new(phone_no: sign_up_params[:phone_no],email: sign_up_params[:email], name: sign_up_params[:name], password: sign_up_params[:password], address: sign_up_params[:streetname], profile_picture: sign_up_params[:profile_picture])
    if user.save
      broadband = Broadband.new(phone_no: sign_up_params[:phone_no],email: sign_up_params[:email], anchorname: sign_up_params[:name], password: sign_up_params[:password], manager_name: sign_up_params[:manager_name],broadband_type_id: sign_up_params[:broadband_type_id],streetname: sign_up_params[:streetname],city: sign_up_params[:city],state_code: sign_up_params[:state_code],zip5: sign_up_params[:zip5],detail: sign_up_params[:summary], banner: sign_up_params[:profile_picture])
      broadband.user_id = user.id
      if broadband.save
        render json: {
          broadband: broadband.as_json(:except => [:password]),
          user: user.as_json,
          access_url: request.base_url+'/organizations/'+broadband.id.to_s+'/activate'.as_json
        }, status: :ok
      else
        user.destroy
        render json: { error: 'Broadband could not be created' }
      end
    else
      render json: { error: 'Email has already been taken' }
    end
  end


  private

  def sign_up_params
    params.require(:organization).permit(:email, :password, :manager_name, :name, :phone_no, :profile_picture, :address, :summary, :state_code, :city, :streetname, :zip5, :broadband_type_id)
  end

end