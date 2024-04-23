require 'rails_helper'

RSpec.describe "MovieDbApi" do
  it "implements search API" do
    results = MovieDbApi.new.search({query: "batman"})
    expect(results[:status]).to eq 200
    expect(results[:data].length).to be > 1
  end

  it "returns error if invalid API key" do
    results = MovieDbApi.new("invalid token").search({query: "batman"})
    expected = { status: 401, error: /Invalid API key/ }
    expect(results).to include(expected)
  end

  it "returns empty array if no query param" do
    results = MovieDbApi.new.search({})
    expected = { status: 200, data: [] }
    expect(results).to include(expected)
  end

  it "returns empty array if no results found" do
    results = MovieDbApi.new.search({})
    expected = { status: 200, data: [] }
    expect(results).to include(expected)
  end
end
