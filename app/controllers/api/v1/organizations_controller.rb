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
    user = User.new sign_up_params.except(:manager_name, :summary, :state_code, :city, :streetname, :zip5, :broadband_type_id)
    if user.save
      organization = Organization.new sign_up_params.except(:profile_picture)
      organization.user_id = user.id
      organization.save
      render json: {
        organization: organization.as_json(:except => [:password]),
        user: user.as_json,
        access_url: request.base_url+'/organizations/'+organization.id.to_s+'/activate'.as_json
      }, status: :ok
    else
      render json: { error: 'Email has already been taken' }
    end
  end


  private

  def sign_up_params
    params.require(:organization).permit(:email, :password, :manager_name, :name, :phone_no, :profile_picture, :address, :summary, :state_code, :city, :streetname, :zip5, :broadband_type_id)
  end

end