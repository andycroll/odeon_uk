require_relative '../../../test_helper'

describe OdeonUk::Html::Screenings do
  let(:described_class) { OdeonUk::Html::Screenings }

  let(:website) { Minitest::Mock.new }

  before { WebMock.disable_net_connect! }

  describe '.at(cinema_id)' do
    subject { described_class.at(71) }

    before do
      website.expect(:showtimes, brighton_showtimes_html, [71])
    end

    it 'returns an array of screening attributes as hashes' do
      OdeonUk::Html::Website.stub :new, website do
        subject.must_be_instance_of(Array)
        subject.each do |screening|
          screening.must_be_instance_of(Hash)
          screening.keys.must_include(:film_name)

          screening.keys.must_include(:time)
          screening[:time].must_be_instance_of(Time)

          screening.keys.must_include(:variant)

          screening.keys.must_include(:dimension)
          screening[:dimension].must_match(/[23]d/)
        end
      end
    end

    it 'returns correct number of screenings' do
      OdeonUk::Html::Website.stub :new, website do
        subject.count.must_equal 133
      end
    end
  end

  private

  def brighton_showtimes_html
    read_file('../../../../fixtures/html/showtimes/brighton.html')
  end

  def read_file(filepath)
    File.read(File.expand_path(filepath, __FILE__))
  end

  def sitemap_html
    read_file('../../../../fixtures/html/sitemap.html')
  end
end
