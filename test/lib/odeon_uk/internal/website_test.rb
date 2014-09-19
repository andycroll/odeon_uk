require_relative '../../../test_helper'

describe OdeonUk::Internal::Website do
  let(:described_class) { OdeonUk::Internal::Website }

  describe '#cinema(id)' do
    subject { described_class.new.cinema(71) }

    before { stub_get('cinemas/odeon/71', brighton_cinema_html) }

    it 'returns a string' do
      subject.class.must_equal String
    end
  end

  describe '#sitemap' do
    subject { described_class.new.sitemap }

    before { stub_get('sitemap/', sitemap_html) }

    it 'returns a string' do
      subject.class.must_equal String
    end
  end

  describe '#showtimes(id)' do
    subject { described_class.new.showtimes(71) }

    before { stub_get('showtimes/week/71?siteId=71', brighton_showtimes_html) }

    it 'returns a string' do
      subject.class.must_equal String
    end
  end

  private

  def brighton_cinema_html
    read_file('../../../../fixtures/cinema/brighton.html')
  end

  def brighton_showtimes_html
    read_file('../../../../fixtures/showtimes/brighton.html')
  end

  def read_file(filepath)
    File.read(File.expand_path(filepath, __FILE__))
  end

  def sitemap_html
    read_file('../../../../fixtures/sitemap.html')
  end

  def stub_get(site_path, response_body)
    url      = "http://www.odeon.co.uk/#{site_path}"
    response = { status: 200, body: response_body, headers: {} }
    stub_request(:get, url).to_return(response)
  end
end
