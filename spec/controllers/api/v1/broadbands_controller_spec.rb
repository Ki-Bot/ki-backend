require 'rails_helper'

RSpec.describe Api::V1::BroadbandsController, type: :controller do
  let(:user) { FactoryGirl.create :user }

  describe 'Broadbands' do
    context 'Search endpoints' do
      before(:each) do
        api_authorization_header user.auth_token
      end
      context 'Search query provided' do
        before(:each) do
          get :search, params: { q: 'street' }
        end
        # it 'responds with hits' do
        #   expect(json_response).to include :hits
        # end
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
      context 'No types provided' do
        before(:each) do
          get :search_by_location
        end
        it 'responds with empty array' do
          expect(json_response).to match_array([])
        end
        it { is_expected.to respond_with :ok }
      end
    end

  end
end
