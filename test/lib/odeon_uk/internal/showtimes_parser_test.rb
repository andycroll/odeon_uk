require_relative '../../../test_helper'

describe OdeonUk::Internal::ShowtimesParser do
  let(:described_class) { OdeonUk::Internal::ShowtimesParser }

  let(:website) { Minitest::Mock.new }

  before { WebMock.disable_net_connect! }

  describe '#films_with_screenings' do
    subject { described_class.new(71).films_with_screenings }

    before do
      website.expect(:showtimes, brighton_showtimes_html, [71])
    end

    it 'returns an non-zero array of film screenings html fragments' do
      OdeonUk::Internal::Website.stub :new, website do
        subject.must_be_instance_of(Array)
        subject.size.must_be :>, 0

        subject.each do |film_html|
          film_html.must_be_instance_of(String)
          film_html.size.must_be :>, 0
        end
      end
    end

    it 'returns an array with correct content' do
      OdeonUk::Internal::Website.stub :new, website do
        subject.each do |html|
          html.must_include('class="film-detail') # screenings group
          html.must_include('class="presentation-info') # title
          html.must_include('class="WEEK') # a performance
          html.must_include('data-start="') # start time
          html.must_include('data-end="') # end time
        end
      end
    end
  end

  private

  def read_file(filepath)
    File.read(File.expand_path(filepath, __FILE__))
  end

  def brighton_showtimes_html
    read_file('../../../../fixtures/brighton-showtimes.html')
  end
end
