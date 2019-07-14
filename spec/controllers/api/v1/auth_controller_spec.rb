require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :controller do
  render_views
  let!(:user) { create(:user) }

  describe '#login' do
    context "with valid email/password" do
      it "returns valid token with expirationa and user info" do
        post :login, format: :json, params: {email: user.email, password: '1234567'}
        expect(response.status).to be(200)
        expect(json['name']).to eq(user.name)
        expect(json['username']).to eq(user.username)
        expect(json['email']).to eq(user.email)
        expect(json['token']).to be_present
        expect(json['exp']).to be_present
      end
    end

    context "with invalid email/password" do
      it "returns unauthorized" do
        post :login, params: {email: 'BadEmail@bademail.com', password: '1234567'}, format: :json
        expect(response.status).to be(401)
      end
    end
  end
end
