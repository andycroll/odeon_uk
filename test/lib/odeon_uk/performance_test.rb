require_relative '../../test_helper'

describe OdeonUk::Performance do
  let(:described_class) { OdeonUk::Performance }
  let(:api_response) { FakeApiResponse.new }

  before { WebMock.disable_net_connect! }
  after { WebMock.allow_net_connect! }

  describe '.at(cinema_id)' do
    subject { described_class.at(cinema_id) }

    describe 'passed Fixnum' do
      let(:cinema_id) { 71 }

      it 'returns an array of performances' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.must_be_instance_of(Array)
          subject.each do |element|
            element.must_be_instance_of(described_class)
          end
        end
      end

      it 'returns at least a sensible number' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.count.must_be :>, 110
        end
      end
    end

    describe 'passed String' do
      let(:cinema_id) { '71' }

      it 'returns an array of performances' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.must_be_instance_of(Array)
          subject.each do |element|
            element.must_be_instance_of(described_class)
          end
        end
      end

      it 'returns at least a sensible number' do
        OdeonUk::Internal::ApiResponse.stub :new, api_response do
          subject.count.must_be :>, 110
        end
      end
    end
  end

  describe '.new' do
    subject { described_class.new(options) }

    describe 'simple' do
      let(:options) do
        {
          film_name:   'The Big Short',
          cinema_id:   71,
          cinema_name: 'Brighton',
          starting_at: Time.utc(2013, 9, 12, 11, 0)
        }
      end

      it 'sets cinema name and film name' do
        subject.film_name.must_equal 'The Big Short'
        subject.cinema_name.must_equal 'Brighton'
      end

      it 'booking url, dimension & varient are set to defaults' do
        subject.booking_url.must_equal nil
        subject.dimension.must_equal '2d'
        subject.variant.must_equal []
      end
    end
  end

  describe '#dimension' do
    let(:options) do
      {
        film_name:   'Ant Man',
        dimension:   '3d',
        cinema_id:   71,
        cinema_name: 'Brighton',
        starting_at: Time.utc(2013, 9, 12, 11, 0)
      }
    end

    subject { described_class.new(options).dimension }

    it 'returns 2d or 3d' do
      subject.must_be_instance_of(String)
      subject.must_equal '3d'
    end
  end

  describe '#starting_at' do
    subject { described_class.new(options).starting_at }

    describe 'with utc time' do
      let(:options) do
        {
          film_name:   'Steve Jobs',
          cinema_id:   71,
          cinema_name: 'Brighton',
          starting_at: Time.utc(2013, 9, 12, 11, 0)
        }
      end

      it 'returns UTC time' do
        subject.must_be_instance_of Time
        subject.must_equal Time.utc(2013, 9, 12, 11, 0)
      end
    end

    describe 'with non-utc time' do
      let(:options) do
        {
          film_name:   'Steve Jobs',
          cinema_id:   71,
          cinema_name: 'Brighton',
          starting_at: Time.new(2013, 9, 12, 11, 0)
        }
      end

      it 'returns UTC time' do
        subject.must_be_instance_of Time
        subject.must_equal Time.utc(2013, 9, 12, 10, 0)
        subject.utc?.must_equal(true)
      end
    end
  end

  describe '#showing_on' do
    let(:options) do
      {
        film_name:   'The Hunger Games',
        cinema_id:   71,
        cinema_name: 'Brighton',
        starting_at: Time.utc(2013, 9, 12, 11, 0)
      }
    end

    subject { described_class.new(options).showing_on }

    it 'returns date of showing' do
      subject.must_be_instance_of(Date)
      subject.must_equal Date.new(2013, 9, 12)
    end
  end

  describe '#variant' do
    subject { described_class.new(options).variant }

    let(:options) do
      {
        film_name:   'Carol',
        cinema_id:   71,
        cinema_name: 'Brighton',
        starting_at: Time.utc(2013, 9, 12, 11, 0),
        variant:     %w(Subtitles Senior)
      }
    end

    it 'is an alphabetically ordered array of lower-cased strings' do
      subject.must_be_instance_of Array
      subject.each { |element| element.must_be_instance_of String }
      subject.must_equal %w(senior subtitles)
    end
  end

end
