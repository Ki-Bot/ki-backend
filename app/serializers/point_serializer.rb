class PointSerializer < ActiveModel::Serializer
  attributes :anchorname, :address, :bldgnbr, :predir, :streetname, :streettype, :suffdir, :city, :state_code, :zip5, :publicwifi, :url, :id, :_geoloc

  def _geoloc
    { lat: object.latitude, lng: object.longitude }
  end
end
