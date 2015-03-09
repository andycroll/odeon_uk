require 'pp'
require_relative '../../../test_helper'

describe OdeonUk::Api::Response do
  let(:described_class) { OdeonUk::Api::Response }

  describe '#all_cinemas' do
    subject { described_class.new.all_cinemas }

    before { stub_post('all-cinemas', nil, all_cinemas_response) }

    it 'returns a Hash' do
      subject.class.must_equal Hash
    end

    it 'contains films key' do
      subject.keys.must_include('sites')
    end
  end

  describe '#app_init' do
    subject { described_class.new.app_init }

    before { stub_post('app-init', nil, app_init_response) }

    it 'returns a Hash' do
      subject.class.must_equal Hash
    end

    it 'contains key named "films"' do
      subject.keys.must_include('films')
    end
  end

  describe '#film_times(cinema_id, film_id)' do
    subject { described_class.new.film_times(cinema_id: 6, film_id: 15_286) }

    before do
      request_body = { 's' => '6', 'm' => '15286' }
      stub_post('film-times', request_body, film_times_response)
    end

    it 'returns a Array' do
      subject.class.must_equal Array
    end

    it 'contains times grouped by day' do
      subject.each do |day|
        day.keys.must_include('date')
        day['attributes'].each do |kind|
          kind.keys.must_include('attribute')
          kind.keys.must_include('showtimes')
        end
      end
    end
  end

  private

  def all_cinemas_response
    read_file('../../../../fixtures/api/all_cinemas.bplist')
  end

  def app_init_response
    read_file('../../../../fixtures/api/app_init.bplist')
  end

  def film_times_response
    read_file('../../../../fixtures/api/film_times.bplist')
  end

  def read_file(filepath)
    File.read(File.expand_path(filepath, __FILE__))
  end

  def stub_post(site_path, request_body, response_body)
    url      = "https://api.odeon.co.uk/2.1/api/#{site_path}"
    response = { status: 200, body: response_body, headers: {} }
    stub_request(:post, url).with(body: request_body).to_return(response)
  end
end
