require 'rails_helper'

RSpec.describe "Movies", type: :request do
  describe "GET /search" do
    it 'returns an error if missing options' do
      get "/movies/search"
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq({error: "Invalid params" }.to_json)
    end

    it 'returns service unavailable if all external APIs dont return results' do
      allow(Movie).to receive(:search).and_return(nil)
      get "/movies/search", params: { query: 'batman' }
      expect(response).to have_http_status(:service_unavailable)
      expect(response.body).to eq({ error: 'Service Unavailable' }.to_json)
    end

    it 'returns movies data if search is successful' do
      # TODO: Use factory for movie objects
      movie = Movie.new(
        title: "Jack Reacher: Never Go Back",
        summary: "Jack Reacher must uncover the truth behind a major government conspiracy in order to clear his name. On the run as a fugitive from the law, Reacher uncovers a potential secret from his past that could change his life forever.",
        year: 2016,
        rating: 4.19
      )
      allow(Movie).to receive(:search).and_return([movie])
      get "/movies/search", params: { query: 'jack' }
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq( { data: [movie.attributes] }.to_json)
    end
  end

end
