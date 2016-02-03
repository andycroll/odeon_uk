require_relative '../../../test_helper'

describe OdeonUk::Api::Cinema do
  include ApiFixturesHelper

  let(:described_class) { OdeonUk::Api::Cinema }

  let(:response) { Minitest::Mock.new }

  before do
    WebMock.disable_net_connect!
  end

  describe '.ids' do
    subject { described_class.ids }

    before do
      response.expect(:all_cinemas, parse(all_cinemas_plist))
    end

    it 'returns an Array of integers' do
      OdeonUk::Api::Response.stub :new, response do
        subject.must_be_instance_of(Array)
        subject.each do |value|
          value.must_be_instance_of(Fixnum)
        end
      end
    end

    it 'returns the correctly sized array' do
      OdeonUk::Api::Response.stub :new, response do
        subject.size.must_be :>, 100
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

    before { response.expect(:all_cinemas, parse(all_cinemas_plist)) }

    describe 'Brighton' do
      let(:id) { 71 }

      it 'returns cinema name' do
        OdeonUk::Api::Response.stub :new, response do
          subject.must_equal 'Brighton'
        end
      end
    end

    describe 'Leicester Square' do
      let(:id) { 105 }

      it 'returns cinema name' do
        OdeonUk::Api::Response.stub :new, response do
          subject.must_equal 'London Leicester Square'
        end
      end
    end
  end

  describe '#locality' do
    subject { described_class.new(id).locality }

    before { response.expect(:all_cinemas, parse(all_cinemas_plist)) }

    describe 'Short Address (Brighton)' do
      let(:id) { 71 }

      before { response.expect(:all_cinemas, parse(all_cinemas_plist)) }

      it 'returns town name' do
        OdeonUk::Api::Response.stub :new, response do
          subject.must_equal 'Brighton'
        end
      end
    end
  end

  describe '#postal_code' do
    subject { described_class.new(id).postal_code }

    describe 'short address' do
      let(:id) { 71 }

      before { response.expect(:all_cinemas, parse(all_cinemas_plist)) }

      it 'returns the postcode' do
        OdeonUk::Api::Response.stub :new, response do
          subject.must_equal 'BN1 2RE'
        end
      end
    end

    describe 'short address (London)' do
      let(:id) { 211 }

      before { response.expect(:all_cinemas, parse(all_cinemas_plist)) }

      it 'returns the postcode' do
        OdeonUk::Api::Response.stub :new, response do
          subject.must_equal 'SE1 8XR'
        end
      end
    end

    describe 'short address (extra London Postcode)' do
      let(:id) { 105 }

      before { response.expect(:all_cinemas, parse(all_cinemas_plist)) }

      it 'returns the postcode' do
        OdeonUk::Api::Response.stub :new, response do
          subject.must_equal 'WC2H 7JY'
        end
      end
    end
  end

  describe '#street_address' do
    subject { described_class.new(id).street_address }

    describe 'short address' do
      let(:id) { 71 }

      before { response.expect(:all_cinemas, parse(all_cinemas_plist)) }

      it 'returns first line of address' do
        OdeonUk::Api::Response.stub :new, response do
          subject.must_equal 'Kingswest'
        end
      end
    end
  end

  describe '#url' do
    subject { described_class.new(id).url }

    describe 'short address' do
      let(:id) { 71 }

      before { response.expect(:all_cinemas, parse(all_cinemas_plist)) }

      it 'returns first line of address' do
        OdeonUk::Api::Response.stub :new, response do
          subject.must_equal 'http://www.odeon.co.uk/cinemas/brighton/71/'
        end
      end
    end
  end
end
