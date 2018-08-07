require 'rails_helper'

RSpec.describe 'Items API', type: :request do
  let!(:todo) { create(:todo) }
  let(:todo_id) { todo.id }
  let!(:items) { create_list(:item, 10, todo_id: todo.id) }
  let(:item_id) { items.last.id }

  describe 'GET /todos/:todo_id/items' do
    before { get "/todos/#{todo_id}/items" }

    context 'when todo_id exists' do
      it_behaves_like 'a successful request'

      it 'returns a list pf items for specific todo' do
        expect(json).not_to be_empty
        expect(json.size).to eq 10
      end
    end

    context 'when todo does not exists' do
      let(:todo_id) { 0 }

      it_behaves_like 'a not_found request'

      it 'returns an error message' do
        expect(json['message']).to match(/Couldn't find Todo with 'id'=[0-9]*/)
      end
    end
  end

  describe 'GET /todos/:todo_id/items/:id' do
    before { get "/todos/#{todo_id}/items/#{item_id}" }

    context 'when the item exists' do
      it_behaves_like 'a successful request'

      it 'returns the requested item' do
        expect(json).not_to be_empty
        expect(json['name']).to eq(items.last.name)
        expect(json['done']).to be_falsy
      end
    end

    context 'when the item does not exist' do
      let(:item_id) { 0 }

      it_behaves_like 'a not_found request'

      it 'returns an error message' do
        subject
        expect(json['message']).to match(/Couldn't find Item with 'id'=[0-9]*/)
      end
    end
  end

  describe 'POST /todos/:todo_id/items' do
    subject(:create_item) { post "/todos/#{todo_id}/items", params: params }
    before { create_item }

    context 'when the params contains the required fields' do
      let(:params) { { name: 'First Item', done: false } }

      it_behaves_like 'an object created request'

      it 'creates the item' do
        expect(json['name']).to eq(params[:name])
        expect(json['done']).to be_falsy
      end
    end

    context 'when the params are invalid' do
      let(:params) { {} }

      it_behaves_like 'an unprocessable entity error'

      it 'returns a validation failure error message' do
        expect(json['message']).to match(/Validation failed:/)
      end
    end
  end

  describe 'PUT /todos/:todo_id/items/:id' do
    before { put "/todos/#{todo_id}/items/#{item_id}", params: params }
    let(:params) { { name: 'A different name' } }

    context 'when the item exists' do
      it_behaves_like 'a no content response'

      it 'updates the item' do
        updated_item = Item.find(item_id)
        expect(updated_item.name).to eq(params[:name])
      end
    end

    context 'when the item does not exist' do
      let(:item_id) { 0 }

      it_behaves_like 'a not_found request'

      it 'returns a not found error message' do
        expect(json['message']).to match(/Couldn't find Item/)
      end
    end
  end

  describe 'DELETE /todos/:todo_id/items/:id' do
    before { delete "/todos/#{todo_id}/items/#{item_id}" }

    it_behaves_like 'a no content response'
  end
end
