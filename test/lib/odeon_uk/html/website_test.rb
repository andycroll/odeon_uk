require_relative '../../../test_helper'

describe OdeonUk::Html::Website do
  include WebsiteFixturesHelper

  let(:described_class) { OdeonUk::Html::Website }

  describe '#cinema(id)' do
    subject { described_class.new.cinema(71) }

    describe 'successful http request' do
      before { stub_get('cinemas/odeon/71/', cinema_html(71)) }

      it 'returns a string' do
        subject.class.must_equal String
      end
    end

    describe 'unsuccessful http request' do
      before { stub_get_with_500('cinemas/odeon/71/') }

      it 'returns an empty string' do
        subject.must_equal ''
      end
    end
  end

  describe '#sitemap' do
    subject { described_class.new.sitemap }

    describe 'successful http request' do
      before { stub_get('sitemap/', sitemap_html) }

      it 'returns a string' do
        subject.class.must_equal String
      end
    end

    describe 'unsuccessful http request' do
      before { stub_get_with_500('sitemap/') }

      it 'returns an empty string' do
        subject.must_equal ''
      end
    end
  end

  describe '#showtimes(id)' do
    subject { described_class.new.showtimes(71) }

    describe 'successful http request' do
      before { stub_get('showtimes/week/71/?siteId=71', showtimes_html(71)) }

      it 'returns a string' do
        subject.class.must_equal String
      end
    end

    describe 'unsuccessful http request' do
      before { stub_get_with_500('showtimes/week/71/?siteId=71') }

      it 'returns an empty string' do
        subject.must_equal ''
      end
    end
  end
end
