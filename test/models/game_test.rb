require 'test_helper'

class GameTest < MiniTest::Unit::TestCase

  def test_game
    date = Date.parse('August 1, 2013')
    g = Game.create!(home_team: 'home', away_team: 'away', date: date, station: 'MLBN')
    assert_equal('home', g.home_team)
    assert_equal('away', g.away_team)
    assert_equal('MLBN', g.station)
    assert_equal(date, g.date)
  end

end
