class Broadband < ApplicationRecord
  include AlgoliaSearch

  has_many :points
  has_many :opening_hours
  accepts_nested_attributes_for :opening_hours, allow_destroy: true

  algoliasearch do
    attribute :anchorname, :address, :bldgnbr, :predir, :streetname, :streettype, :suffdir, :city, :state_code, :zip5, :publicwifi, :url, :id, :_geoloc
    # attribute :_geoloc do
    #   geolocation
    # end

    searchableAttributes ['address', 'city', 'state_code', 'anchorname']
  end

  def self.search(q)
    algolia_search(q)
  end

  def _geoloc
    { lat: latitude.to_f, lng: longitude.to_f }
  end
end
