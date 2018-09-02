require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  let(:user) { create(:user) }
  let!(:todos) { create_list(:todo, 10, created_by: user.id) }
  let(:todo_id) { todos.last.id }
  let(:headers) { valid_headers }
  let(:params) { {} }
  before { subject }

  describe 'GET /todos' do
    subject(:get_all) { get '/todos', params: params, headers: headers }

    it_behaves_like 'a successful request'

    it 'returns a list of todos' do
      expect(json).not_to be_empty
      expect(json.size).to eq 10
    end
  end

  describe 'GET /todos/:id' do
    subject { get "/todos/#{todo_id}", params: params, headers: headers }

    context 'when the record exists' do

      it_behaves_like 'a successful request'

      it 'returns the todo' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end
    end

    context 'when the record does not exist' do
      let(:todo_id) { -1 }

      it_behaves_like 'a not_found request'

      it 'returns an error message' do
        expect(json['message']).to match(/Couldn't find Todo/)
      end
    end
  end

  describe 'POST /todos' do
    subject(:create_todo) { post '/todos', params: params.to_json, headers: headers }

    context 'when there are missing params' do
      it_behaves_like 'an unprocessable entity request'

      it 'returns an error message' do
        create_todo
        expect(json['message']).to match("Validation failed: [a-zA-Z ]* can't be blank")
      end
    end

    context 'when the params are valid' do
      let(:params) { { title: 'A valid test', created_by: '1' } }

      it_behaves_like 'an object created request'

      it 'returns the created todo object' do
        create_todo

        expect(json).not_to be_empty
        expect(json['title']).to eq(params[:title])
        expect(json['created_by']).to eq(params[:created_by])
      end
    end
  end

  describe 'PUT /todos/:id' do
    before { put "/todos/#{todo_id}", params: params.to_json, headers: headers }

    context 'when the params are valid' do
      let(:params) { { title: 'Another title' } }

      it_behaves_like 'a no content response'

      it 'updaets the todo object' do
        expect(response.body).to be_empty
      end
    end
  end

  describe 'DELETE /todos/:id' do
    let(:delete_todo) { delete "/todos/#{todo_id}", params: params, headers: headers }

    context 'when the id exists' do
      it { expect{ delete_todo }.to change{ Todo.all.count }.by(-1) }
    end
  end
end
