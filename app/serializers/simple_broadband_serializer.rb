class SimpleBroadbandSerializer < ActiveModel::Serializer
  attributes :id, :address, :_geoloc, :is_favorite

  def is_favorite
    current_user.present? && current_user.has_favorite?(object)
  end
end
