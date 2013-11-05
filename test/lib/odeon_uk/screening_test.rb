require_relative '../../test_helper'

describe OdeonUk::Screening do

  before { WebMock.disable_net_connect! }

  describe '#new film_name, cinema_name, date, time, varient' do
    it 'stores film_name, cinema_name & when (in UTC)' do
      screening = OdeonUk::Screening.new 'Iron Man 3', 'Brighton', Time.parse('2013-09-12 12:00') # non-UTC time
      screening.film_name.must_equal 'Iron Man 3'
      screening.cinema_name.must_equal 'Brighton'
      screening.when.must_equal Time.utc(2013, 9, 12, 11, 0)
      screening.booking_url.must_equal nil
      screening.varient.must_equal nil
    end

    it 'stores varient if passed' do
      screening = OdeonUk::Screening.new 'Iron Man 3', 'Brighton', Time.utc(2013, 9, 12, 11, 0), nil, '3d'
      screening.film_name.must_equal 'Iron Man 3'
      screening.cinema_name.must_equal 'Brighton'
      screening.when.must_equal Time.utc(2013, 9, 12, 11, 0)
      screening.booking_url.must_equal nil
      screening.varient.must_equal '3d'
    end

    it 'stores booking_url if passed' do
      screening = OdeonUk::Screening.new 'Iron Man 3', 'Brighton', Time.utc(2013, 9, 12, 11, 0), 'http://booking_url'
      screening.film_name.must_equal 'Iron Man 3'
      screening.cinema_name.must_equal 'Brighton'
      screening.when.must_equal Time.utc(2013, 9, 12, 11, 0)
      screening.when.must_equal Time.utc(2013, 9, 12, 11, 0)
      screening.booking_url.must_equal 'http://booking_url'
      screening.varient.must_equal nil
    end
  end

  describe '#date' do
    subject { OdeonUk::Screening.new('Iron Man 3', 'Brighton', Time.utc(2013, 9, 12, 11, 0), '3d').date }
    it 'should return date of showing' do
      subject.must_be_instance_of(Date)
      subject.must_equal Date.new(2013, 9, 12)
    end
  end
end
