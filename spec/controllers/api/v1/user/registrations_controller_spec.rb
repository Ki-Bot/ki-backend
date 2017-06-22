require 'rails_helper'

RSpec.describe Api::V1::Users::RegistrationsController, type: :controller do
  let(:user) {FactoryGirl.create :user}

  describe 'PATCH #update' do
    context 'when user is authenticated' do
      before(:each) do
        api_authorization_header user.auth_token
      end

      context 'when the password confirmation is correct' do
        before(:each) do
          credentials = {password: '12345678', password_confirmation: '12345678'}
          patch :update, params: {user: credentials}
        end

        it 'updates the current user password and returns current user' do
          user.reload
          expect(json_response[:auth_token]).to eql user.auth_token
        end

        it {is_expected.to respond_with 200}
      end

      context 'when the password confirmation is incorrect' do
        before(:each) do
          credentials = {password: '12345678', password_confirmation: '87654321'}
          patch :update, params: {user: credentials}
        end

        it 'returns a json with an error' do
          expect(json_response[:errors].first).to eql "Password confirmation doesn't match Password"
        end

        it {is_expected.to respond_with 422}
      end

      context 'updated user credentials' do
        before(:each) do
          params = {first_name: 'name', last_name: 'lastname'}
          patch :update, params: {user: params}
        end

        it 'updates the current user and returns updated user' do
          user.reload
          expect(json_response[:first_name]).to eql user.first_name
          expect(json_response[:last_name]).to eql user.last_name
        end

        it {is_expected.to respond_with 200}
      end
    end

    context 'when user is not authenticated' do
      before(:each) do
        params = {first_name: 'name', last_name: 'lastname'}
        patch :update, params: {user: params}
      end

      it {is_expected.to respond_with 401}
    end
  end
end