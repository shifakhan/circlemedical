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
    valid_options = options.slice(:query)
    return { status: :unprocessable_entity, error: "Invalid params" } if valid_options.empty?

    result = MovieDbApi.new.search(valid_options)
    if result[:error].present?
      # Call another movie API used as fallback. For now return an error message
      return { status: :service_unavailable, error: "Service Unavailable" }
    end

    { status: :ok, data: result[:data] }
  end
end
