# Read fixtures from disk
module ApiFixturesHelper
  private

  def all_cinemas_plist
    read_fixture('api/all_cinemas')
  end

  def app_init_plist
    read_fixture('api/app_init')
  end

  def film_times_plist(cinema_id, film_id)
    read_fixture("api/film_times/#{cinema_id}-#{film_id}")
  end

  def film_times_plist_random
    read_fixture("api/film_times/#{film_times_plist_names(71).sample}")
  end

  def film_times_plist_names(cinema_id)
    Dir.entries(File.expand_path('../../fixtures/api/film_times', __FILE__))
       .reject { |filename| !filename.match(/\A#{cinema_id}-/) }
       .map { |filename| filename.gsub('.plist', '') }
  end

  def parse(content)
    plist = CFPropertyList::List.new(data: content).value
    CFPropertyList.native_types(plist).fetch('data', {})
  end

  def read_fixture(filepath)
    File.read(File.expand_path("../../fixtures/#{filepath}.plist", __FILE__))
  end

  def stub_post(site_path, request_body, response_body)
    url      = "https://api.odeon.co.uk/2.1/api/#{site_path}"
    response = { status: 200, body: response_body, headers: {} }
    stub_request(:post, url).with(body: request_body).to_return(response)
  end
end
