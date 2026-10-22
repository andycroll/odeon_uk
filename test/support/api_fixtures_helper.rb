# Read fixtures from disk
module ApiFixturesHelper
  private

  def sites_json
    read_fixture('api/sites')
  end

  def showtimes_json(cinema_id)
    read_fixture("api/showtimes-#{cinema_id}")
  end

  def read_fixture(filepath)
    File.read(File.expand_path("../../fixtures/#{filepath}.json", __FILE__))
  end
end
