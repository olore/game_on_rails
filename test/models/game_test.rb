require 'test_helper'

class GameTest < MiniTest::Unit::TestCase #Test::Unit::TestCase
  def test_game
    g = Game.new(:teams => 'some teams', :date => '1999')
    assert_equal('some teams', g.teams)
    assert_equal('1999', g.date)
  end
end
