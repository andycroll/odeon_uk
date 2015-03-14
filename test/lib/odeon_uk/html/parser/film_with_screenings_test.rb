require_relative '../../../../test_helper'

describe OdeonUk::Html::Parser::FilmWithScreenings do
  include FixturesHelper

  let(:described_class) { OdeonUk::Html::Parser::FilmWithScreenings }

  describe '#film_name' do
    subject { described_class.new(film_html).film_name }

    describe 'passed film html' do
      let(:film_html) { showtimes_html('71-0') }

      it 'returns film name' do
        subject.must_equal 'Home'
      end
    end
  end

  describe '#to_a' do
    subject { described_class.new(film_html).to_a }

    describe 'passed film html' do
      let(:film_html) { showtimes_html('71-0') }

      it 'returns an array of hashes of screening attributes' do
        subject.must_be_instance_of Array
        subject.each do |hash|
          hash[:booking_url].must_match 'https://www.odeon.co.uk/'
          hash[:dimension].must_match(/[23]d/)
          hash[:film_name].must_be_instance_of String
          hash[:time].must_be_instance_of Time
          hash[:time].zone.must_equal 'UTC'
        end
      end

      it 'returns the same film title' do
        first_title = subject[0][:film_name]
        subject.each do |hash|
          hash[:film_name].must_equal first_title
        end
      end

      it 'returns at least 1' do
        subject.count.must_be :>=, 1
      end
    end

    describe 'passed imax film html' do
      let(:film_html) { showtimes_html('11-imax') }

      it 'returns an array of hashes of screening attributes' do
        subject.must_be_instance_of Array
        subject.each do |hash|
          hash[:booking_url].must_match 'https://www.odeon.co.uk/'
          hash[:dimension].must_match(/[23]d/)
          hash[:film_name].must_be_instance_of String
          hash[:time].must_be_instance_of Time
          hash[:time].zone.must_equal 'UTC'
        end
      end

      it 'contains imax in the variant' do
        variants = subject.map { |hash| hash[:variant] }
        variants.must_include('imax')
      end

      it 'returns at least 1' do
        subject.count.must_be :>=, 1
      end
    end

    describe 'passed d-box film html' do
      let(:film_html) { showtimes_html('171-d-box') }

      it 'returns an array of hashes of screening attributes' do
        subject.must_be_instance_of Array
        subject.each do |hash|
          hash[:booking_url].must_match 'https://www.odeon.co.uk/'
          hash[:dimension].must_match(/[23]d/)
          hash[:film_name].must_be_instance_of String
          hash[:time].must_be_instance_of Time
          hash[:time].zone.must_equal 'UTC'
        end
      end

      it 'contains d-box in the variant' do
        variants = subject.map { |hash| hash[:variant] }
        variants.must_include('d-box')
      end

      it 'returns at least 1' do
        subject.count.must_be :>=, 1
      end
    end
  end
end
