require 'rails_helper'

class Authentication < ActionController::Base
  include Authenticable
end

RSpec.describe Authenticable do
  let(:authentication) {Authentication.new}
  subject {authentication}

  describe '#current_user' do
    before do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      allow(authentication).to receive(:request).and_return(request)
    end

    it 'returns the user from the authorization header' do
      expect(authentication.current_user.auth_token).to eql @user.auth_token
    end
  end

  describe '#user_signed_in?' do
    context "when there is a user on 'session'" do
      before do
        @user = FactoryGirl.create :user
        allow(authentication).to receive(:current_user).and_return(@user)
      end

      it {is_expected.to be_user_signed_in}
    end

    context "when there is no user on 'session'" do
      before do
        @user = FactoryGirl.create :user
        allow(authentication).to receive(:current_user).and_return(nil)
      end

      it {is_expected.not_to be_user_signed_in}
    end
  end
end