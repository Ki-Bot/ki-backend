require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:password_confirmation) }
  it { is_expected.to respond_to(:auth_token) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to allow_value('example@domain.com').for(:email) }
  it { is_expected.to validate_uniqueness_of(:auth_token) }

  it { is_expected.to be_valid }

  describe '#generate_authentication_token!' do
    it 'generates an unique token' do
      allow(Devise).to receive(:friendly_token).and_return('anuniquetoken123anuniquetoken123')
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql 'anuniquetoken123anuniquetoken123'
    end

    it 'generates another token when one already has been taken' do
      existing_user = FactoryGirl.create(:user, auth_token: 'anuniquetoken123anuniquetoken123')
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eql existing_user.auth_token
    end

    it 'generates 32 character GUID' do
      @user.generate_authentication_token!
      expect(@user.auth_token.length).to eql 32
    end
  end
end