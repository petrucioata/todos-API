require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  let!(:todos) { create_list(:todo, 10) }
  let(:todo_id) { todos.last.id }
  before { subject }

  describe 'GET /todos' do
    subject(:get_all) { get '/todos' }

    it_behaves_like 'a successful request'

    it 'returns a list of todos' do
      expect(json).not_to be_empty
      expect(json.size).to eq 10
    end
  end

  describe 'GET /todos/:id' do
    subject { get "/todos/#{todo_id}" }

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
    subject(:create_todo) { post '/todos', params: params }

    context 'when there are missing params' do
      let(:params) { { title: 'Just a test' } }

      it 'returns status code 422' do
        create_todo
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        create_todo
        expect(json['message']).to match("Validation failed: [a-zA-Z ]* can't be blank")
      end
    end

    context 'when the params are valid' do
      let(:params) { { title: 'A valid test', created_by: '1' } }

      it 'returns status code 201 created' do
        create_todo
        expect(response).to have_http_status(:created)
      end

      it 'returns the created todo object' do
        create_todo

        expect(json).not_to be_empty
        expect(json['title']).to eq(params[:title])
        expect(json['created_by']).to eq(params[:created_by])
      end
    end
  end

  describe 'PUT /todos/:id' do
    let(:update_todo) { put "/todos/#{todo_id}", params: params }

    context 'when the params are valid' do
      let(:params) { { title: 'Another title' } }

      it 'returns status code 204' do
        update_todo
        expect(response).to have_http_status(:no_content)
      end

      it 'updaets the todo object' do
        update_todo
        expect(response.body).to be_empty
      end
    end
  end

  describe 'DELETE /todos/:id' do
    let(:delete_todo) { delete "/todos/#{todo_id}" }

    context 'when the id exists' do
      it { expect{ delete_todo }.to change{ Todo.all.count }.by(-1) }
    end
  end
end
