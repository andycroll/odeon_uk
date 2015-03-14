module FixtureCreator
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
      puts "Create fixture: #{message}"
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
