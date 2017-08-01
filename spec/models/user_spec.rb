require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {FactoryGirl.build(:user)}
  let (:point) {FactoryGirl.create :broadband, broadband_type: FactoryGirl.create(:broadband_type)}

  subject {user}

  it {is_expected.to respond_to(:email)}
  it {is_expected.to respond_to(:password)}
  it {is_expected.to respond_to(:password_confirmation)}
  it {is_expected.to respond_to(:auth_token)}

  # it {is_expected.to validate_presence_of(:email)}
  # it {is_expected.to validate_uniqueness_of(:email).case_insensitive}
  # it {is_expected.to validate_confirmation_of(:password)}
  it {is_expected.to allow_value('example@domain.com').for(:email)}
  it {is_expected.to validate_uniqueness_of(:auth_token)}
  # it {is_expected.to validate_presence_of(:name)}

  it {is_expected.to be_valid}

  it {is_expected.to have_many :points}
  it {is_expected.to have_many :favorites}

  describe '#generate_authentication_token!' do
    it 'generates an unique token' do
      allow(Devise).to receive(:friendly_token).and_return('anuniquetoken123anuniquetoken123')
      user.generate_authentication_token!
      expect(user.auth_token).to eql 'anuniquetoken123anuniquetoken123'
    end

    it 'generates another token when one already has been taken' do
      existing_user = FactoryGirl.create(:user, auth_token: 'anuniquetoken123anuniquetoken123')
      user.generate_authentication_token!
      expect(user.auth_token).not_to eql existing_user.auth_token
    end

    it 'generates 32 character GUID' do
      user.generate_authentication_token!
      expect(user.auth_token.length).to eql 32
    end
  end

  describe '#set favorite point!' do
    before(:each) do
      user.save
      user.set_favorite_point! point
      user.reload
    end

    it 'saves the point' do
      expect(user.favorites.count).to eql 1
    end

    it "doesn't save the same point twice" do
      user.set_favorite_point! point
      user.reload
      expect(user.favorites.count).to eql 1
    end
  end

  describe '#has favorite?' do
    before(:each) {user.save}

    it 'has the point' do
      user.set_favorite_point! point
      expect(user.has_favorite? point).to be true
    end

    it "doesn't have the point" do
      expect(user.has_favorite? point).to be false
    end
  end

  describe '#remove_favorite_point!' do
    before(:each) do
      user.save
      user.set_favorite_point! point
    end

    it 'removes the point' do
      user.remove_favorite_point! point
      user.reload
      expect(user.favorites.count).to eql 0
    end

    it "doesn't remove incorrect points" do
      user.remove_favorite_point! FactoryGirl.create(:broadband, broadband_type: FactoryGirl.create(:broadband_type))
      user.reload
      expect(user.favorites.count).to eql 1
    end
  end
end