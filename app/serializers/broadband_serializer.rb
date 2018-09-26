class BroadbandSerializer < ActiveModel::Serializer
  attributes :id, :email, :manager_name, :phone_no, :anchorname, :address, :bldgnbr, :predir, :streetname, :streettype, :suffdir, :city, :state_code, :zip5, :publicwifi, :url, :detail, :services, :_geoloc, :type, :services, :logo, :banner, :rating, :broadband_type_id

  has_many :opening_hours

  # def is_editable
  #   current_user.present? && current_user.can_edit_broadband(object)
  # end

  # def is_favorite
  #   current_user.present? && current_user.has_favorite?(object)
  # end

  def logo
    object.logo.url.gsub '//s3.amazonaws.com', 'https://s3.us-east-2.amazonaws.com' if object.logo.exists?
  end

  def logo_medium
    object.logo.url(:medium) if object.logo.exists?
  end

  def logo_thumb
    object.logo.url(:thumb) if object.logo.exists?
  end

  def banner
    object.banner.url.gsub '//s3.amazonaws.com', 'https://s3.us-east-2.amazonaws.com' if object.banner.exists?
  end

  def banner_medium
    object.banner.url(:medium) if object.banner.exists?
  end

  def banner_thumb
    object.banner.url(:thumb) if object.banner.exists?
  end

  def type
    object.broadband_type.name if object.broadband_type.present?
  end
end
