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

  def test_parse_date
    guide = ESPNGuide.allocate
    str = "August 1, 7:05 PM ET"
    d = guide.parse_date(str).to_time
    assert_equal 'August', d.strftime('%B')
    assert_equal '1', d.strftime('%-d')
    assert_equal '7', d.strftime('%-l')
    assert_equal '05', d.strftime('%M')
    assert_equal 'PM', d.strftime('%p')
  end

  def test_date_to_str
    expected = "August 1"
    guide = ESPNGuide.allocate
    str = guide.date_to_str(Date.parse('August 1, 7:05 PM ET'))
    assert_equal expected, str
  end

  def test_games_at_date_for_games_on_the_first_of_the_month
    guide = ESPNGuide.new(@espn_doc)
    games = guide.games_at(Date.parse('August 1, 2013'))
    assert_equal 1, games.length
    assert_equal 'MLBN', games.first.station
  end


  def test_games_at_date
    guide = ESPNGuide.new(@espn_doc)
    games = guide.games_at(Date.parse('August 3, 2013'))
    assert_equal 3, games.length
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

  def test_game_parses_home_and_away_teams_with_no_hrefs____damn_you_espn
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
