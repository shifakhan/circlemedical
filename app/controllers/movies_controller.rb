class MoviesController < ApplicationController
  before_action :validate_search_params, only: [:search]

  def search
    movies = Movie.search(params[:query])
    if movies
      movies_attributes = movies.map { |movie| movie.attributes }
      render json: { data: movies_attributes }.to_json, status: :ok
    else
      render json: { error: "Service Unavailable" }, status: :service_unavailable
    end
  end

  private

  def validate_search_params
    render json: { error: "Invalid params" }, status: :unprocessable_entity if params[:query].blank?
  end
end
