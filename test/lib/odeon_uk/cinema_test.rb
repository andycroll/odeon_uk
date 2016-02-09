require_relative '../../test_helper'

describe OdeonUk::Cinema do
  include ApiFixturesHelper

  let(:described_class) { OdeonUk::Cinema }
  let(:api_response) { FakeApiResponse.new }

  before { WebMock.disable_net_connect! }
  after { WebMock.allow_net_connect! }

  describe '.new(id)' do
    subject { described_class.new(id) }

    describe 'Brighton' do
      let(:id) { 71 }

      it 'returns a cinema with a string id' do
        subject.must_be_instance_of(described_class)
        subject.id.must_equal(id.to_s)
      end
    end
  end

  describe '.all' do
    subject { described_class.all }

    it 'returns an array of cinemas' do
      OdeonUk::Internal::ApiResponse.stub :new, api_response do
        subject.must_be_instance_of(Array)
        subject.each do |element|
          element.must_be_instance_of(described_class)
        end
        subject.count.must_be :>, 100
      end
    end
  end

  describe '#adr' do
    subject { described_class.new(id).adr }

    describe 'short address' do
      let(:id) { 71 }

      it 'returns the postcode' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.must_equal(street_address:   'Kingswest',
                             extended_address: nil,
                             locality:         'Brighton',
                             region:           nil,
                             postal_code:      'BN1 2RE',
                             country_name:     'United Kingdom')
        end
      end
    end
  end

  describe '#address' do
    subject { described_class.new(id).address }

    describe 'London address' do
      let(:id) { 105 }

      it 'returns the postcode' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.must_equal(street_address:   '24-26 Leicester Square',
                             extended_address: nil,
                             locality:         'London',
                             region:           nil,
                             postal_code:      'WC2H 7JY',
                             country_name:     'United Kingdom')
        end
      end
    end
  end

  describe '#brand' do
    subject { described_class.new(id).brand }
    describe 'short address' do
      let(:id) { 71 }

      it 'returns the postcode' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.must_equal 'Odeon'
        end
      end
    end
  end

  describe '#country_name' do
    subject { described_class.new(id).country_name }
    describe 'short address' do
      let(:id) { 71 }

      it 'returns the postcode' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.must_equal 'United Kingdom'
        end
      end
    end
  end

  describe '#extended_address' do
    subject { described_class.new(id).extended_address }
    describe 'short address' do
      let(:id) { 71 }

      it 'returns the postcode' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.must_equal ''
        end
      end
    end
  end

  describe '#full_name' do
    subject { described_class.new(id).full_name }
    describe 'Brighton' do
      let(:id) { 71 }

      it 'returns cinema name' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.must_equal 'Odeon Brighton'
        end
      end
    end

    describe 'Leicester Square' do
      let(:id) { 105 }

      it 'returns cinema name' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.must_equal 'Odeon Leicester Square'
        end
      end
    end
  end

  describe '#locality' do
    subject { described_class.new(id).locality }
    describe 'Short Address (Brighton)' do
      let(:id) { 71 }

      it 'returns town name' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.must_equal 'Brighton'
        end
      end
    end
  end

  describe '#name' do
    subject { described_class.new(id).name }
    describe 'Brighton' do
      let(:id) { 71 }

      it 'returns cinema name' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.must_equal 'Brighton'
        end
      end
    end

    describe 'Leicester Square' do
      let(:id) { 105 }

      it 'returns cinema name' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.must_equal 'Leicester Square'
        end
      end
    end
  end

  describe '#postal_code' do
    subject { described_class.new(id).postal_code }
    describe 'short address' do
      let(:id) { 71 }

      it 'returns the postcode' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.must_equal 'BN1 2RE'
        end
      end
    end

    describe 'short address (London)' do
      let(:id) { 211 }

      it 'returns the postcode' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.must_equal 'SE1 8XR'
        end
      end
    end

    describe 'short address (extra London Postcode)' do
      let(:id) { 105 }

      it 'returns the postcode' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.must_equal 'WC2H 7JY'
        end
      end
    end
  end

  describe '#region' do
    subject { described_class.new(id).region }
    describe 'short address' do
      let(:id) { 71 }

      it 'returns the postcode' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.must_equal ''
        end
      end
    end
  end

  describe '#slug' do
    subject { described_class.new(id).slug }

    describe 'short address' do
      let(:id) { 71 }

      it 'returns first line of address' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.must_equal 'odeon-brighton'
        end
      end
    end
  end

  describe '#street_address' do
    subject { described_class.new(id).street_address }

    describe 'short address' do
      let(:id) { 71 }

      it 'returns first line of address' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.must_equal 'Kingswest'
        end
      end
    end
  end

  describe '#url' do
    subject { described_class.new(id).url }

    describe 'short address' do
      let(:id) { 71 }

      it 'returns first line of address' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.must_equal 'http://www.odeon.co.uk/cinemas/brighton/71/'
        end
      end
    end
  end
end
