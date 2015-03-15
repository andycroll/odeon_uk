module FixtureCreator
  class Api
    def all_cinemas!
      write_fixture(:all_cinemas)
    end

    def app_init!
      write_fixture(:app_init)
    end

    def film_times!(cinema_id)
      OdeonUk::Api::Screenings.send(:film_ids, cinema_id).each do |i|
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
        file.write OdeonUk::Api::Response.new.send(:film_times_raw,
                                                   cinema_id,
                                                   film_id)
      end
    end

    def write_fixture(kind)
      FileUtils.mkdir_p kind.to_s
      File.open(fixture(kind), 'w+') do |file|
        log(kind)
        file.write OdeonUk::Api::Response.new.send("#{kind}_raw".to_sym)
      end
    end
  end

  class Html < Struct.new(:cinema_id)
    def cinema!
      write_page_fixture(:cinema)
    end

    def film_node!(index)
      write_node_fixture(index)
    end

    def showtimes!
      write_page_fixture(:showtimes)
    end

    def sitemap!
      write_page_fixture(:sitemap)
    end

    private

    def fixture(name)
      File.expand_path("../../test/fixtures/html/#{name}.html", __FILE__)
    end

    def log(message)
      puts "Create HTML fixture: #{message}"
    end

    def write_node_fixture(index)
      FileUtils.mkdir_p 'showtimes'
      text = "showtimes/#{cinema_id}-#{index}"
      File.open(fixture(text), 'w+') do |file|
        log(text)
        nodes = OdeonUk::Html::Screenings.send(:film_nodes, cinema_id)
        node = if index.is_a?(Fixnum)
          nodes[index]
        else
          nodes.select { |n| !!n.to_s.match(/#{index}/i) }[0]
        end
        file.write(node.to_s)
      end
    end

    def write_page_fixture(kind)
      FileUtils.mkdir_p kind.to_s
      text = kind.to_s + (cinema_id ? "/#{cinema_id}" : '')
      File.open(fixture(text), 'w+') do |file|
        log(text)
        file.write OdeonUk::Html::Website.new.send(*[kind, cinema_id].compact)
      end
    end
  end
end
