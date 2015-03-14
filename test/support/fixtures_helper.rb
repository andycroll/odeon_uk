module FixturesHelper
  private

  def cinema_html(id)
    read_fixture("html/cinema/#{id}")
  end

  def showtimes_html(id, i = nil)
    read_fixture("html/showtimes/#{id}#{ "-#{i}" if i }")
  end

  def sitemap_html
    read_fixture('html/sitemap')
  end

  def read_fixture(filepath)
    File.read(File.expand_path("../../fixtures/#{filepath}.html", __FILE__))
  end

  def stub_get(site_path, response_body)
    url      = "http://www.odeon.co.uk/#{site_path}"
    response = { status: 200, body: response_body, headers: {} }
    stub_request(:get, url).to_return(response)
  end
end
