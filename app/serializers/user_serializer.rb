class UserSerializer < ActiveModel::Serializer
  attributes :email, :name, :created_at, :updated_at, :roles
end