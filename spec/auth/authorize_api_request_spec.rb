require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
  let(:user) { create(:user) }
  let(:header) { { 'Authorization': token_generator(user.id) } }

  describe '#call' do
    context 'when the request is valid' do
      subject(:request) { described_class.new(header) }

      it 'returns user object' do
        result = request.call
        expect(result[:user]).to eq(user)
      end
    end

    context 'when the request is invalid' do
      subject(:request) { described_class.new(header) }

      context 'when the token is missing' do
        let(:header) { {} }
        it { expect{ request.call }.to raise_error(ExceptionHandler::MissingToken, 'Missing token') }
      end

      context 'when the token is invalid' do
        subject(:header) { { 'Authorization': token_generator(5) } }
        it { expect{ request.call }.to raise_error(ExceptionHandler::InvalidToken, /Invalid token/) }
      end

      context 'when the token is expired' do
        let(:header) { { 'Authorization': token_generator(user.id, Time.now.to_i - 10) } }
        it { expect{ request.call }.to raise_error(ExceptionHandler::InvalidToken, /Signature has expired/) }
      end

      context 'when the token is fake' do
        let(:header) { { 'Authorization': 'fakeTokenNow' } }
        it { expect{ request.call }.to raise_error(ExceptionHandler::InvalidToken, /Not enough or too many segments/) }
      end
    end
  end
end
