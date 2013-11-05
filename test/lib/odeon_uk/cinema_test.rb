require_relative '../../test_helper'

describe OdeonUk::Cinema do

  before { WebMock.disable_net_connect! }

  describe '.all' do
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

  describe '.find(id)' do
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

  describe '.new id, name, url' do
    it 'stores id, name, slug and url' do
      cinema = OdeonUk::Cinema.new '23', 'Brighton & Hove', '/cinemas/brighton/71/'
      cinema.id.must_equal 23
      cinema.brand.must_equal 'Odeon'
      cinema.name.must_equal 'Brighton & Hove'
      cinema.slug.must_equal 'brighton-hove'
      cinema.url.must_equal 'http://www.odeon.co.uk/cinemas/brighton/71/'
    end
  end

  describe '#films' do
    let(:cinema) { OdeonUk::Cinema.new('71', 'Brighton & Hove', '/cinemas/brighton/71/') }
    subject { cinema.films }

    before do
      brighton_screenings_body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'odeon-brighton-showtimes.html') )
      stub_request(:get, 'http://www.odeon.co.uk/showtimes/week/71?siteId=71').to_return( status: 200, body: brighton_screenings_body, headers: {} )
    end

    it 'returns an array of films' do
      subject.must_be_instance_of(Array)
      subject.each do |item|
        item.must_be_instance_of(OdeonUk::Film)
      end
    end

    it 'returns correct number of films' do
      subject.count.must_equal 16
    end

    it 'returns uniquely named films' do
      subject.each_with_index do |item, index|
        subject.each_with_index do |jtem, i|
          if index != i
            item.name.wont_equal jtem.name
            item.wont_equal jtem
          end
        end
      end
    end

    it 'returns film objects with correct names' do
      subject.first.name.must_equal 'About Time'
      subject.last.name.must_equal 'White House Down'
    end
  end

  describe '#locality' do
    describe 'short address' do
      let(:cinema) { OdeonUk::Cinema.new('71', 'Brighton', '/cinemas/brighton/71/') }
      subject { cinema.locality }

      before do
        brighton_cinema_body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'odeon-brighton.html') )
        stub_request(:get, 'http://www.odeon.co.uk/cinemas/brighton/71/').to_return( status: 200, body: brighton_cinema_body, headers: {} )
      end

      it 'returns a string' do
        subject.must_be_instance_of String
      end

      it 'returns a string' do
        subject.must_equal 'Brighton'
      end
    end
  end
  describe '#screenings' do
    let(:cinema) { OdeonUk::Cinema.new('71', 'Brighton', '/cinemas/brighton/71/') }
    subject { cinema.screenings }

    before do
      brighton_screenings_body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'odeon-brighton-showtimes.html') )
      stub_request(:get, 'http://www.odeon.co.uk/showtimes/week/71?siteId=71').to_return( status: 200, body: brighton_screenings_body, headers: {} )
    end

    it 'returns an array of screenings' do
      subject.must_be_instance_of(Array)
      subject.each do |item|
        item.must_be_instance_of(OdeonUk::Screening)
      end
    end

    it 'returns screening objects with correct film names' do
      subject.first.film_name.must_equal 'About Time'
      subject.last.film_name.must_equal 'White House Down'
    end

    it 'returns screening objects with correct cinema name' do
      subject.each { |s| s.cinema_name.must_equal 'Brighton' }
    end

    it 'returns screening objects with correct UTC times' do
      subject.first.when.must_equal Time.utc(2013, 9, 14, 11, 20, 0)
      subject.last.when.must_equal Time.utc(2013, 9, 19, 19, 40, 0)
    end
  end

  describe '#screenings_of(film_or_string)' do
    let(:cinema) { OdeonUk::Cinema.new('71', 'Brighton', '/cinemas/brighton/71/') }
    subject { cinema.screenings_of(film_or_string) }

    before do
      brighton_screenings_body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'odeon-brighton-showtimes.html') )
      stub_request(:get, 'http://www.odeon.co.uk/showtimes/week/71?siteId=71').to_return( status: 200, body: brighton_screenings_body, headers: {} )
    end

    describe 'passed string' do
      let(:film_or_string) { 'About Time' }

      it 'returns an array of screenings' do
        subject.must_be_instance_of(Array)
        subject.each do |item|
          item.must_be_instance_of(OdeonUk::Screening)
        end
      end

      it 'returns the correct number of screening objects' do
        subject.count.must_equal 21
      end

      it 'returns screening objects with correct film names' do
        subject.each { |s| s.film_name.must_equal 'About Time' }
      end

      it 'returns screening objects with correct cinema name' do
        subject.each { |s| s.cinema_name.must_equal 'Brighton' }
      end

      it 'returns screening objects with correct UTC times' do
        subject.first.when.must_equal Time.utc(2013, 9, 14, 11, 20, 0)
        subject.last.when.must_equal Time.utc(2013, 9, 19, 19, 30, 0)
      end
    end

    describe 'passed OdeonUk::Film' do
      let(:film_or_string) { OdeonUk::Film.new 'About Time' }

      it 'returns an array of screenings' do
        subject.must_be_instance_of(Array)
        subject.each do |item|
          item.must_be_instance_of(OdeonUk::Screening)
        end
      end

      it 'returns the correct number of screening objects' do
        subject.count.must_equal 21
      end

      it 'returns screening objects with correct film names' do
        subject.each { |s| s.film_name.must_equal 'About Time' }
      end

      it 'returns screening objects with correct cinema name' do
        subject.each { |s| s.cinema_name.must_equal 'Brighton' }
      end

      it 'returns screening objects with correct UTC times' do
        subject.first.when.must_equal Time.utc(2013, 9, 14, 11, 20, 0)
        subject.last.when.must_equal Time.utc(2013, 9, 19, 19, 30, 0)
      end
    end
  end

  describe '#street_address' do
    describe 'short address' do
      let(:cinema) { OdeonUk::Cinema.new('71', 'Brighton', '/cinemas/brighton/71/') }
      subject { cinema.street_address }

      before do
        brighton_cinema_body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'odeon-brighton.html') )
        stub_request(:get, 'http://www.odeon.co.uk/cinemas/brighton/71/').to_return( status: 200, body: brighton_cinema_body, headers: {} )
      end

      it 'returns a string' do
        subject.must_be_instance_of String
      end

      it 'returns a string' do
        subject.must_equal 'Kingswest'
      end
    end
  end
end
