require_relative 'live_helper'

class LiveCinemaTest < Minitest::Test
  def test_all_returns_cinemas
    cinemas = OdeonUk::Cinema.all

    assert(cinemas.all? { |cinema| cinema.instance_of?(OdeonUk::Cinema) })
    assert_operator cinemas.size, :>, 90
    assert_equal 'Brighton', cinemas.detect { |cinema| cinema.id == '824' }.name
  end

  def test_cinemas_have_uk_coordinates
    located = OdeonUk::Cinema.all.select(&:latitude)

    refute_empty located
    located.each do |cinema|
      assert_includes 49.0..61.0, cinema.latitude, "#{cinema.id} #{cinema.name}"
      assert_includes(-9.0..2.0, cinema.longitude, "#{cinema.id} #{cinema.name}")
    end
  end
end

class LivePerformanceTest < Minitest::Test
  def test_at_returns_performances
    tomorrow = Date.today + 1
    performances = OdeonUk::Performance.at(824, from: tomorrow, to: tomorrow)

    assert(performances.all? { |p| p.instance_of?(OdeonUk::Performance) })
    assert_operator performances.count, :>, 10
  end
end
