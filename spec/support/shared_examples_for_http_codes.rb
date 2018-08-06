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
