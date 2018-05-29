class SimpleBroadbandSerializer < ActiveModel::Serializer
  attributes :id, :anchorname, :address, :_geoloc, :is_favorite, :type, :detail, :banner, :rating

  def is_favorite
    current_user.present? && current_user.has_favorite?(object)
  end

  def type
    object.broadband_type.name if object.broadband_type.present?
  end

  def banner
    object.banner.url.gsub '//s3.amazonaws.com', 'https://s3.us-east-2.amazonaws.com' if object.banner.exists?
  end

end
