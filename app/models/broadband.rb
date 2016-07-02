class Broadband < ActiveRecord::Base
  include AlgoliaSearch

  algoliasearch do
    attribute :address, :city, :state_code, :id, :latitude, :longitude
    attributesToIndex ['address', 'city', 'state_code']
  end
end
