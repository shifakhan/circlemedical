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
end
