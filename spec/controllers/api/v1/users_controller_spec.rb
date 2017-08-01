require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) {FactoryGirl.create :user}

  describe 'GET #me' do
    context 'user is authenticated' do
      before(:each) do
        api_authorization_header user.auth_token
        get :me
      end
      it 'returns the information about a user on a hash' do
        expect(json_response[:email]).to eql user.email
      end

      it "doesn't contain auth token" do
        expect(json_response).not_to include :auth_token
      end

      it 'does includes users id' do
        expect(json_response).to include :id
      end

      it { is_expected.to respond_with :ok }
    end

    context 'user is not authenticated' do
      before(:each) do
        get :me
      end

      it {is_expected.to respond_with :unauthorized}
    end
  end

end
