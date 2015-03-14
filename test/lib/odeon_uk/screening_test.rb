require_relative '../../test_helper'

describe OdeonUk::Screening do
  include WebsiteFixturesHelper

  let(:described_class) { OdeonUk::Screening }

  let(:website) { Minitest::Mock.new }

  before do
    WebMock.disable_net_connect!
  end

  describe '.at(cinema_id)' do
    subject { described_class.at(71) }

    before do
      website.expect(:cinema, cinema_html(71), [71])
      website.expect(:showtimes, showtimes_html(71), [71])
    end

    it 'returns an array of screening attributes as hashes' do
      OdeonUk::Html::Website.stub :new, website do
        subject.must_be_instance_of(Array)
        subject.each do |screening|
          screening.must_be_instance_of(described_class)
          screening.cinema_name.must_equal('Brighton')
          screening.cinema_id.must_equal(71)
          screening.film_name.wont_be_nil
          screening.showing_at.must_be_instance_of(Time)
          screening.showing_on.must_be_instance_of(Date)
          screening.dimension.must_match(/[23]d/)
        end
      end
    end

    it 'returns correct number of screenings' do
      OdeonUk::Html::Website.stub :new, website do
        subject.count.must_equal 212
      end
    end
  end
end
