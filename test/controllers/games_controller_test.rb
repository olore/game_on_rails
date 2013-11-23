require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  
  def test_for_date_returns_json
    get :for_date, :date => '2013-08-08', :format => 'json'
    assert_equal 'application/json', @response.content_type
  end

  def test_for_station_returns_json
    get :for_station, :station => 'MLBN', :format => 'json'
    assert_equal 'application/json', @response.content_type
  end

  def test_for_date_returns_games_in_json
    get :for_date, :date => '2013-07-23', :format => 'json'
    games = JSON.parse(@response.body)
    assert_equal 1, games.size
    assert_equal 'Houston', games.first['home_team']
    assert_equal 'Atlanta', games.first['away_team']
  end

  def test_for_station_returns_games_in_json
    get :for_station, :station => 'MLBN', :format => 'json'
    games = JSON.parse(@response.body)
    assert_equal 1, games.size
    assert_equal 'Houston', games.first['home_team']
    assert_equal 'Atlanta', games.first['away_team']
  end

  def test_for_station_returns_games_in_json_ordered_by_date
    get :for_station, :station => 'MLBN', :format => 'json'
    games = JSON.parse(@response.body)
    assert_equal 2, games.size
    assert_equal 'Houston', games.first['home_team']
    assert_equal 'Boston', games.last['home_team']
  end

end
