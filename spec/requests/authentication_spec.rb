require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /auth/login' do
    let!(:user) { create(:user) }
    let(:headers) { valid_headers.except('Authorization') }
    let(:credentials) {
      {
        email: user.email,
        password: user.password
      }
    }
    subject(:login_user) { post '/auth/login', params: credentials.to_json, headers: headers }
    before { login_user }

    context 'when the request is valid' do
      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'when the request is invalid' do
      let(:credentials) {
        {
          email: Faker::Internet.email,
          password: Faker::Internet.password
        }
      }

      it 'returns a failure message' do
        expect(json['message']).to match(/Invalid credentials/)
      end
    end
  end
end
