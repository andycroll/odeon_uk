require_relative '../../../test_helper'

describe OdeonUk::Api::Screenings do
  include ApiFixturesHelper

  let(:described_class) { OdeonUk::Api::Screenings }

  before { WebMock.disable_net_connect! }

  describe '.at(cinema_id)' do
    subject { described_class.at(71) }

    before do
      stub_post('app-init', nil, app_init_plist)
      film_times_plists(71).each do |name|
        film_id = name.match(/(\d+)\.plist/)[1]
        stub_post('film-times',
                  { s: '71', m: film_id },
                  film_times_plist(71, film_id))
      end
    end

    it 'returns an array of screening attributes as hashes' do
      subject.must_be_instance_of(Array)
      subject.each do |screening|
        screening.must_be_instance_of(Hash)
        screening.keys.must_include(:film_name)

        screening.keys.must_include(:time)
        screening[:time].must_be_instance_of(Time)

        screening.keys.must_include(:variant)
        screening[:variant].must_be_instance_of(Array)

        screening.keys.must_include(:dimension)
        screening[:dimension].must_match(/[23]d/)
      end
    end

    it 'returns at least some non-empty variants' do
      variants = subject.map { |screening| screening[:variant] }
      variants.select { |v| !v.empty? }.count.must_be :>, 0
    end

    it 'returns valid variant types' do
      variants = subject.map { |screening| screening[:variant] }
      variants.each do |v|
        if v.length > 0
          v.each { |e| %w(arts kids imax baby senior).must_include(e) }
        end
      end
    end

    it 'returns correct number of screenings' do
      subject.count.must_be :>, 150
    end
  end
end
