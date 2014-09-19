require_relative '../../test_helper'

describe OdeonUk::Cinema do
  let(:described_class) { OdeonUk::Cinema }

  let(:website) { Minitest::Mock.new }

  before do
    WebMock.disable_net_connect!
  end

  describe '.all' do
    subject { described_class.all }

    before do
      website.expect(:sitemap, sitemap_html)
    end

    it 'returns an Array of OdeonUk::Cinemas' do
      OdeonUk::Internal::Website.stub :new, website do
        subject.must_be_instance_of(Array)
        subject.each do |value|
          value.must_be_instance_of(described_class)
        end
      end
    end

    it 'returns the correctly sized array' do
      OdeonUk::Internal::Website.stub :new, website do
        subject.size.must_equal 115
      end
    end
  end

  describe '.find(id)' do
    subject { described_class.find(id) }

    describe 'Brighton' do
      let(:id) { 71 }

      before do
        website.expect(:sitemap, sitemap_html)
        # website.expect(:cinemas, cinema_html('brighton'), [71])
      end

      it 'returns a cinema' do
        OdeonUk::Internal::Website.stub :new, website do
          subject.must_be_instance_of(described_class)

          subject.id.must_equal 71
          subject.brand.must_equal 'Odeon'
          subject.name.must_equal 'Brighton'
          subject.slug.must_equal 'brighton'
          subject.url.must_equal 'http://www.odeon.co.uk/cinemas/brighton/71/'
        end
      end
    end
  end

  describe '.new' do
    it 'removes "London" name prefix' do
      cinema = OdeonUk::Cinema.new 79, 'London - Leicester Square', '/cinemas/london_leicester_square/105/'
      cinema.id.must_equal 79
      cinema.name.must_equal 'Leicester Square'
      cinema.slug.must_equal 'leicester-square'
    end

    it 'removes " - " and replaces it with a colon ": "' do
      cinema = OdeonUk::Cinema.new 208, 'Whiteleys - The Lounge', '/cinemas/whiteleys_the_lounge/208/'
      cinema.id.must_equal 208
      cinema.name.must_equal 'Whiteleys: The Lounge'
      cinema.slug.must_equal 'whiteleys-the-lounge'
    end
  end

  describe '#adr' do
    subject { cinema.adr }

    describe '(brighton)' do
      let(:cinema) do
        described_class.new(71, 'Brighton', '/cinemas/brighton/71/')
      end

      before do
        website.expect(:cinema, cinema_html('brighton'), [71])
      end

      it 'returns the address hash' do
        OdeonUk::Internal::Website.stub :new, website do
          subject.must_equal(
            street_address: 'Kingswest',
            locality: 'Brighton',
            postal_code: 'BN1 2RE',
            country: 'United Kingdom'
          )
        end
      end
    end
  end

  describe '#films' do
    subject { cinema.films }

    let(:cinema) do
      described_class.new(71, 'Brighton', '/cinemas/brighton/71/')
    end

    it 'calls out to Screening object' do
      OdeonUk::Film.stub :at, [:film] do
        subject.must_equal([:film])
      end
    end
  end

  describe '#full_name' do
    subject { cinema.full_name }

    describe 'simple name (brighton)' do
      let(:cinema) do
        OdeonUk::Cinema.new('71', 'Brighton', '/cinemas/brighton/71/')
      end

      before do
        website.expect(:cinema, cinema_html('brighton'), [71])
      end

      it 'returns the brand in the name' do
        OdeonUk::Internal::Website.stub :new, website do
          subject.must_equal 'Odeon Brighton'
        end
      end
    end
  end

  describe '#locality' do
    subject { cinema.locality }

    describe 'short address' do
      let(:cinema) do
        OdeonUk::Cinema.new('71', 'Brighton', '/cinemas/brighton/71/')
      end

      before do
        website.expect(:cinema, cinema_html('brighton'), [71])
      end

      it 'returns town name' do
        OdeonUk::Internal::Website.stub :new, website do
          subject.must_equal 'Brighton'
        end
      end
    end
  end

  describe '#postal_code' do
    subject { cinema.postal_code }

    describe 'short address' do
      let(:cinema) do
        OdeonUk::Cinema.new('71', 'Brighton', '/cinemas/brighton/71/')
      end

      before do
        website.expect(:cinema, cinema_html('brighton'), [71])
      end

      it 'returns the postcode' do
        OdeonUk::Internal::Website.stub :new, website do
          subject.must_equal 'BN1 2RE'
        end
      end
    end

    describe 'short address (London)' do
      let(:cinema) do
        OdeonUk::Cinema.new('211', 'BFI Imax', '/cinemas/bfi_imax/211/')
      end

      before do
        website.expect(:cinema, cinema_html('bfi_imax'), [211])
      end

      it 'returns the postcode' do
        OdeonUk::Internal::Website.stub :new, website do
          subject.must_equal 'SE1 8XR'
        end
      end
    end

    describe 'short address (extra London Postcode)' do
      let(:cinema) do
        OdeonUk::Cinema.new('105',
                            'Leicester Square',
                            '/cinemas/london_leicester_square/105/')
      end

      before do
        website.expect(:cinema, cinema_html('leicester_square'), [105])
      end

      it 'returns the postcode' do
        OdeonUk::Internal::Website.stub :new, website do
          subject.must_equal 'WC2H 7LQ'
        end
      end
    end
  end

  describe '#screenings' do
    subject { cinema.screenings }

    let(:cinema) do
      described_class.new(71, 'Brighton', '/cinemas/brighton/71/')
    end

    it 'calls out to Screening object' do
      OdeonUk::Screening.stub :at, [:screening] do
        subject.must_equal([:screening])
      end
    end
  end

  describe '#street_address' do
    subject { cinema.street_address }

    describe 'short address' do
      let(:cinema) do
        OdeonUk::Cinema.new('71', 'Brighton', '/cinemas/brighton/71/')
      end

      before do
        website.expect(:cinema, cinema_html('brighton'), [71])
      end

      it 'returns first line of address' do
        OdeonUk::Internal::Website.stub :new, website do
          subject.must_equal 'Kingswest'
        end
      end
    end
  end

  private

  def read_file(filepath)
    File.read(File.expand_path(filepath, __FILE__))
  end

  def sitemap_html
    read_file('../../../fixtures/sitemap.html')
  end

  def cinema_html(filename)
    read_file("../../../fixtures/cinema/#{filename}.html")
  end
end
