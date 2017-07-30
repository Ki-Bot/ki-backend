class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :uid, :created_at, :updated_at, :roles, :provider, :oauth_token, :profile_picture
end
