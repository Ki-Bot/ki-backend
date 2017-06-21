require 'rails_helper'

RSpec.describe Api::V1::Users::SessionsController, type: :controller do

  describe 'POST #create' do
    before(:each) do
      @user = FactoryGirl.create :user
    end

    context 'when the credentials are correct' do
      before(:each) do
        credentials = {email: @user.email, password: '12345678'}
        post :create, params: {user: credentials}
      end

      it 'returns the users record corresponding to the given credentials' do
        @user.reload
        expect(json_response[:auth_token]).to eql @user.auth_token
      end

      it {is_expected.to respond_with :success}
    end

    context 'when the credentials are incorrect' do
      before(:each) do
        credentials = {email: @user.email, password: 'invalidpassword'}
        post :create, params: {user: credentials}
      end

      it 'returns a json with an error' do
        expect(json_response[:errors]).to eql 'Invalid email or password'
      end

      it {is_expected.to respond_with :unprocessable_entity}
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryGirl.create :user
      @old_token = @user.auth_token
    end

    context 'when users has a valid authentication token' do
      before(:each) do
        api_authorization_header @user.auth_token
        delete :destroy
      end

      it "users's token should change" do
        @user.reload
        expect(@user.auth_token).not_to eql @old_token
      end

      it {is_expected.to respond_with :no_content}
    end

    context 'when users has an invalid authentication token' do
      before(:each) do
        api_authorization_header 'invalidtokeninvalidtokeninvalidt'
        delete :destroy
      end

      it "users's token shouldn't change" do
        @user.reload
        expect(@user.auth_token).to eql @old_token
      end

      it {is_expected.to respond_with :unauthorized}
    end

  end

end
