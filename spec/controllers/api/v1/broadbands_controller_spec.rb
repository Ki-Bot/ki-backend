require 'rails_helper'

RSpec.describe Api::V1::BroadbandsController, type: :controller do
  let(:user) { FactoryGirl.create :user }

  describe 'GET #search' do
    context 'User is authenticated' do
      before(:each) do
        api_authorization_header user.auth_token
      end
      context 'Search query provided' do
        before(:each) do
          get :search, params: { q: 'street' }
        end
        it 'responds with hits' do
          expect(json_response).to include :hits
        end
        it { is_expected.to respond_with :ok }
      end
      context 'No search query provided' do
        before(:each) do
          get :search
        end
        it 'responds with error' do
          expect(json_response).to include :error
        end
        it { is_expected.to respond_with :unprocessable_entity }
      end
    end
    context 'User is not authenticated' do
      before(:each) do
        get :search
      end
      it { is_expected.to respond_with :unauthorized }
    end
  end
end
