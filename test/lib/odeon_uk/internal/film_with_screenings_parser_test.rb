require_relative '../../../test_helper'

describe OdeonUk::Internal::FilmWithScreeningsParser do

  describe '#name' do
    subject { OdeonUk::Internal::FilmWithScreeningsParser.new(film_html).name }

    describe 'passed valid film html with simple name' do
      let(:film_html) { read_film_html('about-time') }

      it 'returns the film name' do
        subject.must_equal('About Time')
      end
    end

    describe 'passed valid film html with 2d name' do
      let(:film_html) { read_film_html('star-trek-into-darkness-2d') }

      it 'returns the film name' do
        subject.must_equal('Star Trek Into Darkness')
      end
    end

    describe 'passed valid film html with autism text' do
      let(:film_html) { read_film_html('autism-friendly-planes') }

      it 'returns the film name' do
        subject.must_equal('Planes')
      end
    end

    describe 'passed valid film html with ROH live screening' do
      let(:film_html) { read_film_html('royal-opera-house-turandot') }

      it 'returns the film name' do
        subject.must_equal('Royal Opera House: Turandot 2013')
      end
    end
  end

  def read_film_html(filename)
    path = '../../../../fixtures/odeon-brighton-showtimes'
    File.read(File.expand_path("#{path}/#{filename}.html", __FILE__))
  end
end
