# == Schema Information
#
# Table name: broadbands
#
#  anchorname :string
#  address    :string
#  bldgnbr    :string
#  predir     :string
#  streetname :string
#  streettype :string
#  suffdir    :string
#  city       :string
#  state_code :string
#  zip5       :string
#  latitude   :string
#  longitude  :string
#  publicwifi :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Broadband < ActiveRecord::Base
  include AlgoliaSearch

  algoliasearch do
    attribute :address, :city, :state_code, :id
    attribute :_geoloc do
      { lat: self.latitude, lng: self.longitude }
    end


    attributesToIndex ['address', 'city', 'state_code']
  end
end
