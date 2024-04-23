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
end
