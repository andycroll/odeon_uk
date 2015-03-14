require_relative '../../test_helper'

describe OdeonUk::Cinema do
  include FixturesHelper

  let(:described_class) { OdeonUk::Cinema }

  let(:website) { Minitest::Mock.new }

  before do
    WebMock.disable_net_connect!
  end

  describe 'with HTML parsing' do
    describe '.all' do
      subject { described_class.all }

      before do
        website.expect(:sitemap, sitemap_html)
      end

      it 'returns an Array of OdeonUk::Cinemas' do
        OdeonUk::Html::Website.stub :new, website do
          subject.must_be_instance_of(Array)
          subject.each do |value|
            value.must_be_instance_of(described_class)
          end
        end
      end

      it 'returns the correctly sized array' do
        OdeonUk::Html::Website.stub :new, website do
          subject.size.must_equal 115
        end
      end
    end

    describe '.new(id)' do
      subject { described_class.new(id) }

      describe 'Brighton' do
        let(:id) { 71 }

        before do
          website.expect(:sitemap, sitemap_html)
        end

        it 'returns a cinema' do
          OdeonUk::Html::Website.stub :new, website do
            subject.must_be_instance_of(described_class)

            subject.id.must_equal 71
            subject.brand.must_equal 'Odeon'
            subject.name.must_equal 'Brighton'
            subject.slug.must_equal 'odeon-brighton'
            subject.url.must_equal 'http://www.odeon.co.uk/cinemas/brighton/71/'
          end
        end
      end
    end

    describe '#adr' do
      subject { described_class.new(71).adr }

      describe '(brighton)' do
        before { website.expect(:cinema, cinema_html(71), [71]) }

        it 'returns the address hash' do
          OdeonUk::Html::Website.stub :new, website do
            subject.must_equal(
              street_address: 'Kingswest',
              locality:       'Brighton',
              postal_code:    'BN1 2RE',
              country_name:   'United Kingdom'
            )
          end
        end
      end
    end

    describe '#brand' do
      subject { described_class.new(id).brand }

      describe 'cinema name with London' do
        let(:id) { 105 }

        it 'removes "London" name prefix' do
          subject.must_equal 'Odeon'
        end
      end
    end

    describe '#full_name' do
      subject { described_class.new(71).full_name }

      describe 'simple name (brighton)' do
        before { website.expect(:sitemap, sitemap_html) }

        it 'returns the brand in the name' do
          OdeonUk::Html::Website.stub :new, website do
            subject.must_equal 'Odeon Brighton'
          end
        end
      end
    end

    describe '#locality' do
      subject { described_class.new(71).locality }

      before { website.expect(:cinema, cinema_html(71), [71]) }

      it 'returns town name' do
        OdeonUk::Html::Website.stub :new, website do
          subject.must_equal 'Brighton'
        end
      end
    end

    describe '#name' do
      subject { described_class.new(id).name }

      before { website.expect(:sitemap, sitemap_html) }

      describe 'cinema name with London' do
        let(:id) { 105 }

        it 'removes "London" name prefix' do
          OdeonUk::Html::Website.stub :new, website do
            subject.must_equal 'Leicester Square'
          end
        end
      end

      describe 'cinema name with dashes' do
        let(:id) { 208 }

        it 'removes " - " and replaces it with a colon ": "' do
          OdeonUk::Html::Website.stub :new, website do
            subject.must_equal 'Whiteleys: The Lounge'
          end
        end
      end
    end

    describe '#postal_code' do
      subject { described_class.new(id).postal_code }

      describe 'short address' do
        let(:id) { 71 }

        before { website.expect(:cinema, cinema_html(71), [71]) }

        it 'returns the postcode' do
          OdeonUk::Html::Website.stub :new, website do
            subject.must_equal 'BN1 2RE'
          end
        end
      end

      describe 'short address (London)' do
        let(:id) { 211 }

        before { website.expect(:cinema, cinema_html(211), [211]) }

        it 'returns the postcode' do
          OdeonUk::Html::Website.stub :new, website do
            subject.must_equal 'SE1 8XR'
          end
        end
      end

      describe 'short address (extra London Postcode)' do
        let(:id) { 105 }

        before { website.expect(:cinema, cinema_html(105), [105]) }

        it 'returns the postcode' do
          OdeonUk::Html::Website.stub :new, website do
            subject.must_equal 'WC2H 7LQ'
          end
        end
      end
    end

    describe '#screenings' do
      subject { described_class.new(71).screenings }

      it 'calls out to Screening object' do
        OdeonUk::Screening.stub :at, [:screening] do
          subject.must_equal([:screening])
        end
      end
    end

    describe '#slug' do
      subject { described_class.new(71).slug }

      describe 'simple name (brighton)' do
        before { website.expect(:sitemap, sitemap_html) }

        it 'returns the brand in the name' do
          OdeonUk::Html::Website.stub :new, website do
            subject.must_equal 'odeon-brighton'
          end
        end
      end
    end

    describe '#street_address' do
      subject { described_class.new(id).street_address }

      describe 'short address' do
        let(:id) { 71 }

        before { website.expect(:cinema, cinema_html(71), [71]) }

        it 'returns first line of address' do
          OdeonUk::Html::Website.stub :new, website do
            subject.must_equal 'Kingswest'
          end
        end
      end
    end

    describe '#url' do
      subject { described_class.new(71).url }

      describe 'brighton' do
        before { website.expect(:sitemap, sitemap_html) }

        it 'returns the brand in the name' do
          OdeonUk::Html::Website.stub :new, website do
            subject.must_equal 'http://www.odeon.co.uk/cinemas/brighton/71/'
          end
        end
      end
    end
  end
end
