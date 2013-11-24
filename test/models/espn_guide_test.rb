require 'test_helper'

class ESPNGuideTest < MiniTest::Unit::TestCase
  def setup
    @espn_doc = parse_espn_doc
  end

  def test_intialize_with_no_params_makes_http_call
    ESPNGuide.any_instance.expects(:open).with(ESPNGuide::URL).returns("")
    guide = ESPNGuide.new
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

  def test_collects_all_oddrow_and_evenrow_trs
    Game.destroy_all
    g = ESPNGuide.new(@espn_doc)
    g.generate
    assert_equal 35, Game.count
    g = Game.all.order(:date)
    assert_equal Time.parse('2013-07-31 19:00 EDT'), g.first.date.to_time
    assert_equal Time.parse('2013-09-29 13:35 EDT'), g.last.date.to_time
  end

  private

  def parse_espn_doc
    f = File.open(File.expand_path(File.dirname(__FILE__) + "/../../test/fixtures/espn.go.com-mlb-television.html"))
    doc = Nokogiri::HTML(f)
    f.close
    doc
  end

end
