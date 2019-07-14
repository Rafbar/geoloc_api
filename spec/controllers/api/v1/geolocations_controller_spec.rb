require 'rails_helper'

RSpec.describe Api::V1::GeolocationsController, type: :controller do
  render_views
  let(:user) { create(:user) }
  let!(:geoloc_1) { create(:geo_location) }
  let!(:geoloc_2) { create(:geo_location, key: '192.168.0.2') }
  let(:valid_token) { JwtToken.encode({user_id: user.id}) }
  let(:invalid_token) { 'invalidtokentest' }

  describe 'valid token request' do
    before do
      @request.headers['Authorization'] = valid_token
    end

    context "#index" do
      it 'returns an array of geolocations' do
        get :index, format: :json
        expect(response.status).to eq(200)
        expect(json.count).to eq(2)
      end
    end

    context '#show' do
      it 'returns geoloc information for a valid id' do
        get :show, format: :json, params: {id: geoloc_1.id}
        expect(response.status).to eq(200)
        expect(json['key']).to eq(geoloc_1.key)
        expect(json['ip']).to eq(geoloc_1.ip)
      end

      it 'returns geoloc information for a valid key' do
        get :show, format: :json, params: {id: geoloc_2.key}
        expect(response.status).to eq(200)
        expect(json['key']).to eq(geoloc_2.key)
        expect(json['ip']).to eq(geoloc_2.ip)
      end      

      it 'returns not_found for a nonexistent geoloc' do
        get :show, format: :json, params: {id: '12345678'}
        expect(response.status).to eq(404)
      end
    end

    context '#update' do
      it 'returns geoloc information' do
        patch :update, format: :json, params: {id: geoloc_1.id, key: 'www.google.com'}
        expect(response.status).to eq(200)
        expect(json['key']).to eq('www.google.com')
      end
    end

    context '#delete' do
      it 'returns ok on succesful destroy' do
        delete :destroy, format: :json, params: {id: geoloc_1.id}
        expect(response.status).to eq(200)
      end
    end    
  end

  describe 'invalid token request' do
    before do
      @request.headers['Authorization'] = invalid_token
    end

    context '#show' do
      it 'returns unathorized' do
        get :show, format: :json, params: {id: geoloc_1.id}
        expect(response.status).to eq(401)
      end
    end
  end
end
