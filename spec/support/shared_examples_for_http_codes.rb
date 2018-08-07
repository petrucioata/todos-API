shared_examples 'a successful request' do
  it 'returns status code 200' do
    expect(response).to have_http_status(:ok)
  end
end

shared_examples 'a not_found request' do
  it 'returns status code 404' do
    expect(response).to have_http_status(:not_found)
  end
end

shared_examples 'an object created request' do
  it 'returns status code 201' do
    expect(response).to have_http_status(:created)
  end
end

shared_examples 'an unprocessable entity request' do
  it 'returns status code 422' do
    expect(response).to have_http_status(:unprocessable_entity)
  end
end

shared_examples 'a no content response' do
  it 'returns status code 204' do
    expect(response).to have_http_status(:no_content)
  end
end
