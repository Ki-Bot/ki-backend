require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  let (:admin_user) {FactoryGirl.build(:admin_user, email: FFaker::Internet.email, password: '12345678', password_confirmation: '12345678')}
  subject { admin_user }

  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:password_confirmation) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to allow_value('example@domain.com').for(:email) }

  it { is_expected.to be_valid }
end
