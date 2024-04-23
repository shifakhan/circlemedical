require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe 'validations' do
    it 'a valid movie' do
      movie = Movie.new(
        title: "Jack Reacher: Never Go Back",
        summary: "Jack Reacher must uncover the truth behind a major government conspiracy in order to clear his name. On the run as a fugitive from the law, Reacher uncovers a potential secret from his past that could change his life forever.",
        year: 2016,
        rating: 4.19
      )
      expect(movie.valid?).to eq(true)
    end

    it 'validates presence of attributes' do
      movie = Movie.new
      expect(movie.valid?).to eq(false)
      errors = {
        :rating=>["can't be blank"],
        :summary=>["can't be blank"],
        :title=>["can't be blank"],
        :year=>["can't be blank"]
      }
      expect(movie.errors.messages).to eq(errors)
    end
  end

  describe 'search' do
    it 'returns an error if missing options' do
      expect(Movie.search(random: {})).to eq({ status: :unprocessable_entity, error: "Invalid params" })
    end

    it 'returns service unavailable if all APIs are down' do
      movie_db_api = double("MovieDbApi")
      allow(movie_db_api).to receive(:search).and_return(
        { status: 401, error: 'Unauthorized'}
      )
      allow(MovieDbApi).to receive(:new).and_return(movie_db_api)

      expect(Movie.search(query: "batman")).to eq({ status: :service_unavailable, error: "Service Unavailable" })
    end

    it 'returns movies if search is successful' do
      movie = Movie.new(
        title: "Jack Reacher: Never Go Back",
        summary: "Jack Reacher must uncover the truth behind a major government conspiracy in order to clear his name. On the run as a fugitive from the law, Reacher uncovers a potential secret from his past that could change his life forever.",
        year: 2016,
        rating: 4.19
      )
      movie_db_api = double("MovieDbApi")
      allow(movie_db_api).to receive(:search).and_return(
        { status: 200, data: [movie] }
      )
      allow(MovieDbApi).to receive(:new).and_return(movie_db_api)

      expect(Movie.search(query: "jack")).to eq({ status: :ok, data: [movie] })
    end
  end
end
