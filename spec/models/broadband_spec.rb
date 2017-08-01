require 'rails_helper'

RSpec.describe Broadband, type: :model do
  let (:broadband_type) {FactoryGirl.build(:broadband_type)}
  let (:broadband) {FactoryGirl.build(:broadband, broadband_type: broadband_type)}

  subject {broadband}

  it {is_expected.to respond_to(:anchorname)}
  it {is_expected.to respond_to(:address)}
  it {is_expected.to respond_to(:bldgnbr)}
  it {is_expected.to respond_to(:predir)}
  it {is_expected.to respond_to(:streetname)}
  it {is_expected.to respond_to(:streettype)}
  it {is_expected.to respond_to(:suffdir)}
  it {is_expected.to respond_to(:city)}
  it {is_expected.to respond_to(:state_code)}
  it {is_expected.to respond_to(:zip5)}
  it {is_expected.to respond_to(:latitude)}
  it {is_expected.to respond_to(:longitude)}
  it {is_expected.to respond_to(:publicwifi)}
  it {is_expected.to respond_to(:url)}

  it {is_expected.to be_valid}

  it {is_expected.to have_many :points}
end
