class SimpleBroadbandSerializer < ActiveModel::Serializer
  attributes :id, :anchorname, :address, :_geoloc, :is_favorite, :type

  def is_favorite
    current_user.present? && current_user.has_favorite?(object)
  end

  def type
    object.broadband_type.name if object.broadband_type.present?
  end
end
