require_relative '../../../test_helper'

describe OdeonUk::Internal::FilmWithScreeningsParser do

  describe '#film_name' do
    subject { OdeonUk::Internal::FilmWithScreeningsParser.new(film_html).film_name }

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

    describe 'passed valid film html with Met Opera screening' do
      let(:film_html) { read_film_html('met-opera-eugene-onegin') }

      it 'returns the film name' do
        subject.must_equal('Met Opera: Eugene Onegin 2013')
      end
    end

    describe 'passed valid film html with Met Opera screening' do
      let(:film_html) { read_film_html('cinemagic-echo-planet') }

      it 'returns the film name' do
        subject.must_equal('Echo Planet')
      end
    end

    describe 'passed valid film html with UK Jewish Film Festival' do
      let(:film_html) { read_film_html('ukjff-from-cable-street-to-brick-lane') }

      it 'returns the film name' do
        subject.must_equal('From Cable Street To Brick Lane')
      end
    end

    describe 'passed valid film html with NT Encore' do
      let(:film_html) { read_film_html('national-theatre-live-frankenstein') }

      it 'returns the film name' do
        subject.must_equal('National Theatre: Frankenstein')
      end
    end

    describe 'passed valid film html with NT Encore' do
      let(:film_html) { read_film_html('nt-live-war-horse') }

      it 'returns the film name' do
        subject.must_equal('National Theatre: War Horse')
      end
    end

    describe 'passed valid film html with Bolshoi Ballet' do
      let(:film_html) { read_film_html('bolshoi-spartacus-live') }

      it 'returns the film name' do
        subject.must_equal('Bolshoi: Spartacus')
      end
    end

    describe 'passed valid film html with Globe' do
      let(:film_html) { read_film_html('globe-on-screen-twelfth-night') }

      it 'returns the film name' do
        subject.must_equal('Globe: Twelfth Night')
      end
    end

    describe 'passed valid film html with RSC' do
      let(:film_html) { read_film_html('rsc-richard-ii') }

      it 'returns the film name' do
        subject.must_equal('Royal Shakespeare Company: Richard II')
      end
    end
  end

  describe '#screenings' do
    subject { OdeonUk::Internal::FilmWithScreeningsParser.new(film_html).screenings }

    describe 'passed valid film html' do
      let(:film_html) { read_film_html('about-time') }

      it 'returns an array of screenings' do
        subject.must_be_instance_of Array
        subject.each do |element|
          element.must_be_instance_of OdeonUk::Screening
        end
      end

      it 'returns an array of screenings of the correct film' do
        subject.each do |element|
          element.film_name.must_equal 'About Time'
        end
      end

      it 'returns the correct number of screenings' do
        subject.count.must_equal 21
      end
    end
  end

  def read_film_html(filename)
    path = '../../../../fixtures/odeon-brighton-showtimes'
    File.read(File.expand_path("#{path}/#{filename}.html", __FILE__))
  end
end
