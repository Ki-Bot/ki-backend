require 'rails_helper'

RSpec.describe Point, type: :model do
  let (:point) {FactoryGirl.build(:point, user: FactoryGirl.create(:user), broadband: FactoryGirl.create(:broadband, broadband_type: FactoryGirl.create(:broadband_type)))}

  subject {point}

  it { is_expected.to be_valid }

  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :broadband }
end
