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

  describe '#showings' do
    subject { OdeonUk::Internal::FilmWithScreeningsParser.new(film_html).showings }

    describe 'passed valid film html' do
      let(:film_html) { read_film_html('about-time') }

      it 'returns an hash of varients => array of times' do
        subject.must_be_instance_of Hash
        subject.each do |key, value|
          key.must_equal '2D'
          value.must_be_instance_of Array
          value.each do |element|
            element.must_be_instance_of Time
            element.zone.must_equal 'UTC'
          end
        end
      end

      it 'returns the correct number of screenings' do
        subject['2D'].count.must_equal 21
      end

      it 'returns UTC times for showings' do
        # about times are from British Summer Time UTC+1
        # the actual show time is 20:30 from the fixture
        subject['2D'].last.must_equal Time.utc(2013, 9, 19, 19, 30, 0)
      end
    end

    describe 'passed valid film html' do
      let(:film_html) { read_film_html('thor-the-dark-world', 'manchester') }

      it 'returns an hash of varients => array of times' do
        subject.must_be_instance_of Hash
        subject.keys.must_equal ['2D', 'IMAX 3D', '3D']
        subject.values.each do |value|
          value.must_be_instance_of Array
          value.each do |element|
            element.must_be_instance_of Time
            element.zone.must_equal 'UTC'
          end
        end
      end

      it 'returns the correct number of screenings' do
        subject['2D'].count.must_equal 1
        subject['3D'].count.must_equal 1
        subject['IMAX 3D'].count.must_equal 37
      end

      it 'returns UTC times for showings' do
        # about times are from GMT
        # the actual show time is 00:01 from the fixture
        subject['2D'].last.must_equal Time.utc(2013, 10, 30, 0, 1, 0)
      end
    end
  end

  def read_film_html(filename, cinema='brighton')
    path = "../../../../fixtures/#{cinema}-showtimes"
    File.read(File.expand_path("#{path}/#{filename}.html", __FILE__))
  end
end
