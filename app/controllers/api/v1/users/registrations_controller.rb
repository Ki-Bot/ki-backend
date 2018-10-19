class Api::V1::Users::RegistrationsController < Api::ApplicationController
  skip_before_action :authenticate_with_token, only: [:create, :resend_code]

  resource_description do
    name 'Registration'
    short 'Registration endpoints'
    description 'Endpoints used for user registration'
  end

  def_param_group :user do
    param :name, String, 'Name of the user'
    param :password, String, required: true
    param :password_confirmation, String, required: true
  end

  def_param_group :user_signup do
    param :user, Hash, required: true, action_aware: true do
      param :email, String, required: true
      param :phone_no, String, required: true
      param :profile_picture, String, required: true
      param_group :user
    end
  end

  def_param_group :user_update do
    param :user, Hash, required: true, action_aware: true do
      param_group :user
    end
  end

  api! 'Sign up'
  param_group :user_signup
  formats [:json]
  # POST /resource
  def create
    user = User.new sign_up_params

    respond_with do |format|
      format.json { 
        begin
          user.save!
          user.welcome_email
          render :json => user.to_json(only: 
            [
              :id, 
              :name, 
              :email, 
              :address, 
              :phone_no, 
              :profile_picture
            ]
          ), 
            status: 200 # , serializer: nil
        rescue => e 
          render :json => { message: e }, status: 400
        end
      }
    end
  end

  api :PATCH, '/users', 'Update currently authenticated user'
  api :PUT, '/users', 'Update currently authenticated user'
  error code: 401, desc: 'Unauthorized'
  param_group :user_update
  formats [:json]
  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    user = current_user
    user.update update_params

    render_updated_resource user, except: :auth_token do |u|
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in u
    end
  end

  def resend_code
    user = User.find_by(email: params[:email])

    if !user.nil?
      user.generate_authentication_token!
      user.welcome_email
      render :json => { message: 'Please check your email inbox to find the code.' }, status: 200
    else
      render :json => { message: 'Unable to find email adddress.' }, status: 400
    end
  end
  
  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :phone_no, :profile_picture, :address)
  end

  def update_params
    params.require(:user).permit(:password, :password_confirmation, :name)
  end
end
