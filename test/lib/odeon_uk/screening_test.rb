require_relative '../../test_helper'

describe OdeonUk::Screening do
  let(:described_class) { OdeonUk::Screening }

  let(:website) { Minitest::Mock.new }

  before { WebMock.disable_net_connect! }

  describe '.at(cinema_id)' do
    subject { described_class.at(71) }

    before do
      website.expect(:showtimes, brighton_showtimes_html, [71])
      website.expect(:sitemap, sitemap_html)
    end

    it 'returns an array of screenings' do
      OdeonUk::Internal::Website.stub :new, website do
        subject.must_be_instance_of(Array)
        subject.each do |screening|
          screening.must_be_instance_of(described_class)
        end
      end
    end

    it 'returns correct number of screenings' do
      OdeonUk::Internal::Website.stub :new, website do
        subject.count.must_equal 214
      end
    end
  end

  describe '#showing_on' do
    subject { described_class.new(options).showing_on }

    let(:options) do
      {
        film_name:   'Guardians of the Galaxy',
        cinema_id:   71,
        cinema_name: 'Odeon Brighton',
        time:        Time.utc(2014, 9, 12, 11, 0),
      }
    end

    it 'should return date of screening' do
      subject.must_be_instance_of(Date)
      subject.must_equal Date.new(2014, 9, 12)
    end
  end

  describe '#variant' do
    subject { described_class.new(options).variant }

    describe 'passed array' do
      let(:options) do
        {
          film_name:   'Guardians of the Galaxy',
          cinema_id:   71,
          cinema_name: 'Odeon Brighton',
          time:        Time.utc(2014, 9, 12, 11, 0),
          variant:     %w(Kids BABY)
        }
      end

      it 'is an alphabetically ordered array of lower-cased strings' do
        subject.must_be_instance_of Array
        subject.each do |tag|
          tag.must_be_instance_of String
        end
        subject.must_equal %w(baby kids)
      end
    end

    describe 'passed string' do
      let(:options) do
        {
          film_name:   'Guardians of the Galaxy',
          cinema_id:   71,
          cinema_name: 'Odeon Brighton',
          time:        Time.utc(2014, 9, 12, 11, 0),
          variant:     'Kids BABY'
        }
      end

      it 'is an alphabetically ordered array of lower-cased strings' do
        subject.must_be_instance_of Array
        subject.each do |tag|
          tag.must_be_instance_of String
        end
        subject.must_equal %w(baby kids)
      end
    end
  end

  private

  def brighton_showtimes_html
    read_file('../../../fixtures/showtimes/brighton.html')
  end

  def read_file(filepath)
    File.read(File.expand_path(filepath, __FILE__))
  end

  def sitemap_html
    read_file('../../../fixtures/sitemap.html')
  end
end
