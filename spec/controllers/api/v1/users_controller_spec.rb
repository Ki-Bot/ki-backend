require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe 'GET #me' do
    let(:user) { FactoryGirl.create :user }
    before(:each) do
      api_authorization_header user.auth_token
      get :me
    end

    it 'returns the information about a user on a hash' do
      expect(json_response[:email]).to eql user.email
    end

    it {is_expected.to respond_with 200}
  end

end
