require_relative '../../../test_helper'

describe OdeonUk::Html::Cinema do
  include FixturesHelper

  let(:described_class) { OdeonUk::Html::Cinema }

  let(:website) { Minitest::Mock.new }

  before do
    WebMock.disable_net_connect!
  end

  describe '.ids' do
    subject { described_class.ids }

    before do
      website.expect(:sitemap, sitemap_html)
    end

    it 'returns an Array of OdeonUk::Html::Cinemas' do
      OdeonUk::Html::Website.stub :new, website do
        subject.must_be_instance_of(Array)
        subject.each do |value|
          value.must_be_instance_of(Fixnum)
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

      it 'returns a cinema' do
        subject.must_be_instance_of(described_class)
        subject.id.must_equal(id)
      end
    end
  end

  describe '#name' do
    subject { described_class.new(id).name }

    before { website.expect(:sitemap, sitemap_html) }

    describe 'Brighton' do
      let(:id) { 71 }

      it 'returns cinema name' do
        OdeonUk::Html::Website.stub :new, website do
          subject.must_equal 'Brighton'
        end
      end
    end

    describe 'Leicester Square' do
      let(:id) { 105 }

      it 'returns cinema name' do
        OdeonUk::Html::Website.stub :new, website do
          subject.must_equal 'London - Leicester Square'
        end
      end
    end
  end

  describe '#locality' do
    subject { described_class.new(id).locality }

    before { website.expect(:sitemap, sitemap_html) }

    describe 'Short Address (Brighton)' do
      let(:id) { 71 }

      before { website.expect(:cinema, cinema_html(71), [71]) }

      it 'returns town name' do
        OdeonUk::Html::Website.stub :new, website do
          subject.must_equal 'Brighton'
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
end
