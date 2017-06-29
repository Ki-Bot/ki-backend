class BroadbandSerializer < ActiveModel::Serializer
  attributes :id, :anchorname, :address, :bldgnbr, :predir, :streetname, :streettype, :suffdir, :city, :state_code, :zip5, :publicwifi, :url, :_geoloc, :is_editable

  has_many :opening_hours

  def is_editable
    current_user.present? && current_user.broadbands.include?(object)
  end
end
