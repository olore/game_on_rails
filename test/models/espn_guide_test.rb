require 'test_helper'

class GameOnTest < MiniTest::Unit::TestCase #Test::Unit::TestCase
  def setup
    @espn_doc = parse_espn_doc
  end

  def test_returns_a_list_of_games
    games = ESPNGuide.games_for(@espn_doc, 'MLBN')    
    assert_equal 11, games.length
  end

  def test_games_have_teams
    games = ESPNGuide.games_for(@espn_doc, 'MLBN')    
    g = games.first
    assert_equal("Pittsburgh", g.home_team)
    assert_equal("St. Louis", g.away_team)
  end

  def test_game_parses_home_and_away_teams
    teams = "<a href=http://espn.go.com/mlb/team/_/name/bos/boston-red-sox>Boston</a> @ <a href=http://espn.go.com/mlb/team/_/name/bal/baltimore-orioles>Baltimore</a>"
    away, home = ESPNGuide.parse_home_away_teams(teams)
    assert_equal("Baltimore", home)
    assert_equal("Boston", away)
  end

  def test_game_parses_home_and_away_teams_with_quotes_damn_you_espn
    teams = "<a href=\"http://espn.go.com/mlb/team/_/name/bos/boston-red-sox\">Boston</a> @ <a href=\"http://espn.go.com/mlb/team/_/name/bal/baltimore-orioles\">Baltimore</a>"
    away, home = ESPNGuide.parse_home_away_teams(teams)
    assert_equal("Baltimore", home)
    assert_equal("Boston", away)
  end

  def test_game_parses_home_and_away_teams_with_no_hrefs_damn_you_espn
    teams = "Boston @ Baltimore"
    away, home = ESPNGuide.parse_home_away_teams(teams)
    assert_equal("Baltimore", home)
    assert_equal("Boston", away)
  end

  private

  def parse_espn_doc
    f = File.open(File.expand_path(File.dirname(__FILE__) + "/../../test/fixtures/espn.go.com-mlb-television.html"))
    doc = Nokogiri::HTML(f)
    f.close
    doc
  end

end
