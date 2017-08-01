require 'factory_girl'
FactoryGirl.define do
  factory :broadband do
    anchorname {FFaker::Company.name}
    address {FFaker::AddressUS.street_address}
    city {FFaker::AddressUS.city}
    state_code {FFaker::AddressUS.state_abbr}
    publicwifi {FFaker::Boolean.random}
    url {FFaker::Internet.http_url}
  end
end
