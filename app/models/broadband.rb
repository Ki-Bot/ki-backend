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
  belongs_to :broadband_type

  algoliasearch do
    attribute :anchorname, :address, :bldgnbr, :predir, :streetname, :streettype, :suffdir, :city, :state_code, :zip5, :publicwifi, :url, :id, :_geoloc
    # attribute :_geoloc do
    #   geolocation
    # end
    attribute :type do
      broadband_type.present? ? broadband_type.name : ''
    end

    searchableAttributes ['address', 'city', 'state_code', 'anchorname']
    attributesForFaceting [:type]
  end

  def self.search(q, location = nil)
    # algolia_search(q)
    index = Algolia::Index.new(name)
    hash = {}
    hash[:aroundLatLng] = location if q.blank?
    json = index.search(q, hash)
    hit_ids = json['hits'].map { |hit| hit['objectID'].to_i }
    Broadband.where('id IN (?)', hit_ids).sort_by { |x| hit_ids.index x.id }
  end

  def self.filter(q, types)
    filters = []
    types.each do |type|
      filters << ('type:"' + type + '"')
    end
    filter_text = filters.join(' OR ')
    index = Algolia::Index.new(name)
    json = index.search(q, filters: filter_text)
    hit_ids = json['hits'].map { |hit| hit['objectID'].to_i }
    Broadband.where('id IN (?)', hit_ids).sort_by { |x| hit_ids.index x.id }

    # algolia_search(q, filters: filter_text)
    # algolia_search_for_facet_values('type', 'Hospitals')
    # results = algolia_search_for_facet_values(q, '' {
    #     query: q#,
    #     filters: filter_text  #'(category:Book OR category:Ebook) AND _tags:published'
    # })
    # results
  end

  def _geoloc
    { lat: latitude.to_f, lng: longitude.to_f }
  end
end
