require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  render_views
  let(:user) { create(:user) }
  let(:user_2) { create(:user, username: 'user2name') }
  let(:valid_token) { JwtToken.encode({user_id: user.id}) }
  let(:invalid_token) { 'invalidtokentest' }

  describe 'valid token request' do
    before do
      @request.headers['Authorization'] = valid_token
    end

    context '#show' do
      it 'returns user information for the current user id' do
        get :show, format: :json, params: {id: user.id}
        expect(response.status).to eq(200)
        expect(json['email']).to eq(user.email)
      end

      it 'returns unathorized for a different user' do
        get :show, format: :json, params: {id: user_2.id}
        expect(response.status).to eq(401)
      end
    end

    context '#update' do
      it 'returns user information' do
        patch :update, format: :json, params: {id: user.id, name: 'TestName'}
        expect(response.status).to eq(200)
        expect(json['name']).to eq('TestName')
      end
    end

    context '#delete' do
      it 'returns user information' do
        delete :destroy, format: :json, params: {id: user.id}
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
        get :show, format: :json, params: {id: user.id}
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'without token' do
    context "#create" do
      context "with valid params" do
        let(:params) {{
          password: '1234567', 
          password_confirmation: '1234567', 
          email: 'testemail@email.com',
          username: 'testusername',
          name: 'testname'}}

        it 'creates user' do
          post :create, format: :json, params: params
          expect(response.status).to eq(200)
          expect(json['email']).to eq(params[:email])
        end
      end

      context "with invalid params" do
        let(:params) {{
          password: '12345', 
          password_confirmation: '123456', 
          email: 'testemail'
          }}

        it 'returns unprocessable entity' do
          post :create, format: :json, params: params
          expect(response.status).to eq(422)
          expect(json['user'].count).to eq(4)
          expect(json['user']['email']).to eq(['is invalid'])
        end
      end
    end
  end

end
