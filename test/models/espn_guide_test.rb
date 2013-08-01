require 'test_helper'

class ESPNGuideTest < MiniTest::Unit::TestCase
  def setup
    @espn_doc = parse_espn_doc
  end

  def test_intialize_with_no_params_makes_http_call
    ESPNGuide.any_instance.expects(:open).with(ESPNGuide::URL).returns("")
    guide = ESPNGuide.new
  end

  def test_initialize
    guide = ESPNGuide.new(@espn_doc)
    games = guide.games_for('MLBN')
    assert_equal 11, games.length
  end

  def test_game_parses_home_and_away_teams
    teams = "<a href=http://espn.go.com/mlb/team/_/name/bos/boston-red-sox>Boston</a> @ <a href=http://espn.go.com/mlb/team/_/name/bal/baltimore-orioles>Baltimore</a>"
    guide = ESPNGuide.new(@espn_doc)
    away, home = guide.parse_home_away_teams(teams)
    assert_equal("Baltimore", home)
    assert_equal("Boston", away)
  end

  def test_game_parses_home_and_away_teams_with_quotes_damn_you_espn
    teams = "<a href=\"http://espn.go.com/mlb/team/_/name/bos/boston-red-sox\">Boston</a> @ <a href=\"http://espn.go.com/mlb/team/_/name/bal/baltimore-orioles\">Baltimore</a>"
    guide = ESPNGuide.new(@espn_doc)
    away, home = guide.parse_home_away_teams(teams)
    assert_equal("Baltimore", home)
    assert_equal("Boston", away)
  end

  def test_game_parses_home_and_away_teams_with_no_hrefs_damn_you_espn
    teams = "Boston @ Baltimore"
    guide = ESPNGuide.new(@espn_doc)
    away, home = guide.parse_home_away_teams(teams)
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
