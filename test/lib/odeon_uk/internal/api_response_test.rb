require_relative '../../../test_helper'

describe OdeonUk::Internal::ApiResponse do
  include ApiFixturesHelper

  let(:described_class) { OdeonUk::Internal::ApiResponse }

  describe '#app_init' do
    subject { described_class.new.app_init }

    before { stub_post('app-init', nil, app_init_plist) }

    it 'returns a hash' do
      subject.class.must_equal Hash
      subject.keys.must_equal(%w(films offers))
    end
  end

  describe '#all_cinemas' do
    subject { described_class.new.all_cinemas }

    before { stub_post('all-cinemas', nil, all_cinemas_plist) }

    it 'returns a hash' do
      subject.class.must_equal Hash
      subject.keys.must_equal(%w(sites))
    end
  end

  describe '#showtimes(id)' do
    subject { described_class.new.film_times(71, 15130) }

    before do
      stub_post('film-times',
                { s: '71', m: '15130' },
                film_times_plist_random)
    end

    it 'returns an array' do
      subject.class.must_equal Array
      subject.each { |group| group.keys.must_equal(%w(date attributes)) }
    end
  end
end
