class Movie
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :title, :string
  attribute :summary, :string
  attribute :year, :integer
  attribute :rating, :decimal

  validates :title, presence: true
  validates :summary, presence: true
  validates :year, presence: true
  validates :rating, presence: true

  def self.search(options)
    result = MovieDbApi.new.search(options)
    if result[:error].present?
      # Call another movie API used as fallback. For now return an error message
      return nil
    end
    result[:data]
  end
end
