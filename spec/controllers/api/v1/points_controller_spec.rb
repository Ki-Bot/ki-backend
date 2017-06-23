require 'rails_helper'

RSpec.describe Api::V1::PointsController, type: :controller do
  let (:user) {FactoryGirl.create :user}
  let (:point) {FactoryGirl.create :point, user: user, broadband: FactoryGirl.create(:broadband)}

  describe 'GET #index' do
    it {flunk}
  end

  describe 'POST #create' do
    it {flunk}
  end

  describe 'DELETE #destroy' do
    it {flunk}
  end
end
