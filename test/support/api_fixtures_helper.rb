module ApiFixturesHelper
  private

  def all_cinemas_plist
    read_fixture('api/all_cinemas')
  end

  def app_init_plist
    read_fixture('api/app_init')
  end

  def film_times_plist(cinema_id:, film_id:)
    read_fixture("api/film_times/#{cinema_id}-#{film_id}")
  end

  def parse(content)
    CFPropertyList.native_types(CFPropertyList::List.new(data: content).value)
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
