class BroadbandSerializer < ActiveModel::Serializer
  attributes :id, :anchorname, :address, :bldgnbr, :predir, :streetname, :streettype, :suffdir, :city, :state_code, :zip5, :publicwifi, :url, :_geoloc, :is_editable

  def is_editable
    current_user && current_user.broadbands.include?(object)
  end
end
