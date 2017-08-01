require 'rails_helper'

RSpec.describe Api::V1::PointsController, type: :controller do
  let (:user) { FactoryGirl.create :user }
  let (:broadband_type) { FactoryGirl.create(:broadband_type) }
  let (:broadband) { FactoryGirl.create :broadband, broadband_type: broadband_type }
  let (:point) { FactoryGirl.create :point, user: user, broadband: broadband }

  describe 'GET #index' do
    context 'User is authenticated' do
      before(:each) do
        api_authorization_header user.auth_token
        get :index
      end
      it 'should include _geoloc' do
        expect(json_response).to all(include(:_geoloc))
      end
      it { is_expected.to respond_with :ok }
    end
    context 'User is not authenticated' do
      before(:each) do
        get :index
      end
      it { is_expected.to respond_with :unauthorized }
    end
  end

  describe 'POST #create' do
    context 'User is authenticated' do
      before(:each) do
        api_authorization_header user.auth_token
      end
      context 'Broadband exists' do
        let (:new_broadband) { FactoryGirl.create(:broadband, broadband_type: broadband_type) }
        before(:each) do
          post :create, params: { id: new_broadband.id }
        end
        it { is_expected.to respond_with :ok }
      end
      context 'Broadband doesn\'t exist' do
        before(:each) do
          post :create, params: { id: 0 }
        end
        it 'should return error' do
          expect(json_response).to include(:error)
        end
        it { is_expected.to respond_with :ok }
      end
    end
    context 'User is not authenticated' do
      before(:each) do
        post :create
      end
      it { is_expected.to respond_with :unauthorized }
    end
  end

  describe 'DELETE #destroy' do
    context 'User is authenticated' do

      before(:each) do
        api_authorization_header user.auth_token
      end

      context 'Point exists' do
        before(:each) do
          user.favorites << broadband
          delete :destroy, params: { id: broadband.id }
        end
        it { is_expected.to respond_with :ok }
      end

      context 'Point doesn\'t exist' do
        before(:each) do
          delete :destroy, params: { id: 0 }
        end
        it 'should return error' do
          expect(json_response).to include(:error)
        end
        it { is_expected.to respond_with :ok }
      end
    end
    context 'User is not authenticated' do
      before(:each) do
        delete :destroy, params: { id: broadband.id }
      end
      it { is_expected.to respond_with :unauthorized }
    end
  end
end
