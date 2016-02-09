module FixtureCreator
  class Api
    def all_cinemas!
      write_fixture(:all_cinemas)
    end

    def app_init!
      write_fixture(:app_init)
    end

    def film_times!(cinema_id)
      OdeonUk::Performance.send(:film_ids_at, cinema_id).each do |i|
        write_film_times_fixture(cinema_id, i)
      end
    end

    private

    def fixture(name)
      File.expand_path("../../test/fixtures/api/#{name}.plist", __FILE__)
    end

    def log(message)
      puts "Create API fixture: #{message}"
    end

    def write_film_times_fixture(cinema_id, film_id)
      FileUtils.mkdir_p 'film_times'
      text = "film_times/#{cinema_id}-#{film_id}"
      File.open(fixture(text), 'w+') do |file|
        log(text)
        file.write OdeonUk::Internal::ApiResponse.new.send(:film_times_raw,
                                                           cinema_id,
                                                           film_id)
      end
    end

    def write_fixture(kind)
      FileUtils.mkdir_p kind.to_s
      File.open(fixture(kind), 'w+') do |file|
        log(kind)
        file.write OdeonUk::Internal::ApiResponse.new.send("#{kind}_raw".to_sym)
      end
    end
  end
end
