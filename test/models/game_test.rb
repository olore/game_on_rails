require 'test_helper'

class GameTest < MiniTest::Unit::TestCase

  def test_game
    g = Game.new(:home_team => 'home', :away_team => 'away', :date => '1999')
    assert_equal('home', g.home_team)
    assert_equal('away', g.away_team)
    assert_equal('1999', g.date)
  end
end
