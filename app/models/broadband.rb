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
