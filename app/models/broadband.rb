class Broadband < ApplicationRecord
  include AlgoliaSearch

  has_attached_file :banner, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/images/:style/missing_banner.png', validate_media_type: false
  # validates_attachment_content_type :banner, :content_type => ['image/jpeg', 'image/png']
  do_not_validate_attachment_file_type :banner

  has_attached_file :logo, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/images/:style/missing_logo.png', validate_media_type: false
  # validates_attachment_content_type :logo, :content_type => ['image/jpeg', 'image/png']
  do_not_validate_attachment_file_type :logo

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
