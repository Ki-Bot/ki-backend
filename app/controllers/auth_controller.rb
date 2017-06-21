class AuthController < ApiController

  def authenticate_user
    user = User.find_by(provider: params[:provider], uid: params[:uid], name: params[:name])
    if user.present?
      render json: payload(user)
    else
      render json: {errors: ['User params didnt meet our criteria.']}, status: :unauthorized
    end
  end

  private #######################################

  def payload(user)
    return nil unless user.try(:id)
    Jbuilder.new do |payload_builder|
      payload_builder.auth_token JwtToken.encode({user_id: user.id})
      payload_builder.user do |user_builder|
        user_builder.id   user.id
        user_builder.uid  user.uid
        user_builder.name user.name
      end
    end.target!
  end

end