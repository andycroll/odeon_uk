require_relative '../../test_helper'

describe OdeonUk::Screening do

  before { WebMock.disable_net_connect! }

  describe '#new film_name, cinema_name, date, time, varient' do
    it 'stores film_name, cinema_name & when (in UTC)' do
      screening = OdeonUk::Screening.new 'Iron Man 3', 'Brighton', '2013-09-12', '11:00'
      screening.film_name.must_equal 'Iron Man 3'
      screening.cinema_name.must_equal 'Brighton'
      screening.when.must_equal Time.utc(2013, 9, 12, 11, 0)
      screening.varient.must_equal nil
    end

    it 'stores varient if passed' do
      screening = OdeonUk::Screening.new 'Iron Man 3', 'Brighton', '2013-09-12', '11:00', '3d'
      screening.film_name.must_equal 'Iron Man 3'
      screening.cinema_name.must_equal 'Brighton'
      screening.when.must_equal Time.utc(2013, 9, 12, 11, 0)
      screening.varient.must_equal '3d'
    end
  end

  describe '#date' do
    subject { OdeonUk::Screening.new('Iron Man 3', 'Brighton', '2013-09-12', '11:30', '3d').date }
    it 'should return date of showing' do
      subject.must_be_instance_of(Date)
      subject.must_equal Date.new(2013, 9, 12)
    end
  end

  describe '#date_s' do
    subject { OdeonUk::Screening.new('Iron Man 3', 'Brighton', '2013-09-12', '11:30', '3d').date_s }
    it 'should return date as a string' do
      subject.must_be_instance_of(String)
      subject.must_equal '2013-09-12'
    end
  end

  describe '#time_s' do
    subject { OdeonUk::Screening.new('Iron Man 3', 'Brighton', '2013-09-12', '11:30', '3d').time_s }
    it 'should return time as a string' do
      subject.must_be_instance_of(String)
      subject.must_equal '11:30'
    end
  end
end
