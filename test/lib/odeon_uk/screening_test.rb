require_relative '../../test_helper'

describe OdeonUk::Screening do

  before { WebMock.disable_net_connect! }

  describe '#new film_name, cinema_name, date, time, varient' do
    it 'stores film_name, cinema_name & when' do
      screening = OdeonUk::Screening.new 'Iron Man 3', 'Brighton', '2013-09-12', '11:00'
      screening.film_name.must_equal 'Iron Man 3'
      screening.cinema_name.must_equal 'Brighton'
      screening.when.must_equal Time.new(2013, 9, 12, 11, 0)
      screening.varient.must_equal nil
    end

    it 'stores varient if passed' do
      screening = OdeonUk::Screening.new 'Iron Man 3', 'Brighton', '2013-09-12', '11:00', '3d'
      screening.film_name.must_equal 'Iron Man 3'
      screening.cinema_name.must_equal 'Brighton'
      screening.when.must_equal Time.new(2013, 9, 12, 11, 0)
      screening.varient.must_equal '3d'
    end
  end
end
