require_relative 'live_helper'

class LiveCinemaTest < Minitest::Test
  def test_all_returns_cinemas
    cinemas = OdeonUk::Cinema.all

    assert(cinemas.all? { |cinema| cinema.instance_of?(OdeonUk::Cinema) })
    assert_operator cinemas.size, :>, 90
    assert_equal 'Brighton', cinemas.detect { |cinema| cinema.id == '824' }.name
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
