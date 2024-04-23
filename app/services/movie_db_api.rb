class MovieDbApi
  include HTTParty

  base_uri 'https://api.themoviedb.org/3'

  def initialize(token = nil)
    @token = token || Rails.application.credentials.dig(:themoviedb, Rails.env.to_sym)
  end

  def search(options)
    valid_options = options.slice(:query, :year).merge!(api_key: @token)
    response = self.class.get('/search/movie', query: valid_options)
    body = JSON.parse(response.body)
    case response.code
    when 200
      movies = body['results'].map do |movie|
        Movie.new(
          title: movie['title'],
          summary: movie['overview'],
          year: DateTime.parse(movie['release_date']).year,
          rating: movie['vote_average']
        )
      end
      { status: 200, data: movies }
    else
      { status: response.code, error: body['status_message']}
    end
  end
end
