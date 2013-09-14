require_relative '../../test_helper'

describe OdeonUk::Cinema do

  before { WebMock.disable_net_connect! }

  describe '#all' do
    subject { OdeonUk::Cinema.all }

    before do
      sitemap_body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'odeon-sitemap.html') )
      stub_request(:get, 'http://www.odeon.co.uk/sitemap/').to_return( status: 200, body: sitemap_body, headers: {} )
    end

    it 'returns an Array of Odeon::Cinemas' do
      subject.must_be_instance_of(Array)
      subject.each do |value|
        value.must_be_instance_of(OdeonUk::Cinema)
      end
    end

    it 'returns the correctly sized array' do
      subject.size.must_equal 114
    end
  end

  describe '#find(id)' do
    let(:id) { 71 }

    subject { OdeonUk::Cinema.find(id) }

    before do
      sitemap_body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'odeon-sitemap.html') )
      stub_request(:get, 'http://www.odeon.co.uk/sitemap/').to_return( status: 200, body: sitemap_body, headers: {} )

      # cinema_page_body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'odeon-brighton.html') )
      # stub_request(:get, 'http://www.odeon.co.uk/cinema/brighton/23/').to_return( status: 200, body: cinema_page_body, headers: {} )
    end

    it 'returns a cinema' do
      subject.must_be_instance_of(OdeonUk::Cinema)

      subject.id.must_equal 71
      subject.brand.must_equal 'Odeon'
      subject.name.must_equal 'Brighton'
      subject.slug.must_equal 'brighton'
      subject.url.must_equal 'http://www.odeon.co.uk/cinemas/brighton/71/'
    end
  end

  describe '#find_by_name name' do
    let(:name) { 'Tunbridge Wells' }

    subject { OdeonUk::Cinema.find_by_name(name) }
  end

  describe '#new id, name, url' do
    it 'stores id, name, slug and url' do
      cinema = OdeonUk::Cinema.new '23', 'Brighton & Hove', '/cinemas/brighton/71/'
      cinema.id.must_equal 23
      cinema.brand.must_equal 'Odeon'
      cinema.name.must_equal 'Brighton & Hove'
      cinema.slug.must_equal 'brighton-hove'
      cinema.url.must_equal 'http://www.odeon.co.uk/cinemas/brighton/71/'
    end
  end

end
