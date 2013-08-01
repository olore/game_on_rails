require 'test_helper'

class GameOnTest < MiniTest::Unit::TestCase #Test::Unit::TestCase
  def setup
    @espn_doc = parse_espn_doc
  end

  def test_returns_a_list_of_games
    games = ESPNGuide.games_for(@espn_doc, 'MLBN')    
    assert_equal 11, games.length
  end

  private

  def parse_espn_doc
    f = File.open(File.expand_path(File.dirname(__FILE__) + "/../../test/fixtures/espn.go.com-mlb-television.html"))
    doc = Nokogiri::HTML(f)
    f.close
    doc
  end

end
