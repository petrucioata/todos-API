require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { build(:user) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:params) {
    attributes_for(:user, password_confirmation: user.password)
  }
  subject(:create_account) { post '/signup', params: params.to_json, headers: headers }

  describe 'POST /signup' do
    before { create_account }

    context 'when the request is valid' do
      it_behaves_like 'an object created request'

      it 'returns success message' do
        expect(json['message']).to match(/Account created successfully/)
      end

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'when the request is invalid' do
      let(:params) { {} }

      it_behaves_like 'an unprocessable entity request'

      it 'returns a failure message' do
        expect(json['message'])
          .to match(/Validation failed: Password can't be blank. Name can't be blank. Email can't be blank/)
      end
    end
  end
end
