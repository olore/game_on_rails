require 'open-uri'

class ESPNGuide
  STATIONS = %w( MLBN FOX TBS ESPN )
  URL = 'http://espn.go.com/mlb/television'

  def initialize(doc = nil)
    @doc = doc || Nokogiri::HTML(open(URL))
  end

  def games_for(station)
    parse_games_for(station)
  end

  def games_at(date)
    date_str = "#{date_to_str(date)},"
    parse_games_for(date_str)
  end
  


  #private ?
  
  def parse_games_for(str)
    games = []
    @doc.xpath("//table/tr[td//text()[contains(., '#{str}')]]").each do |row|
      date_time   = parse_date(row.at_xpath('td[1]').text)

      teams       = row.at_xpath('td[2]').text
      away, home  = parse_home_away_teams(teams)

      station = row.at_xpath('td[3]').text
      games << Game.create!(date:      date_time,
                            home_team: home,
                            away_team: away,
                            station:   station)
    end
    games
  end

  def parse_home_away_teams(teams)
    if teams =~ /<a href/
      away = teams.match(/<a.*>(.*?)<\/a> @ /)
      home = teams.match(/@ <a.*>(.*?)<\/a>/)
    else
      away = teams.match(/(.*?) @ /)
      home = teams.match(/.*@ (.*?)$/)
    end

    return away[1], home[1]
  end


  #Date format: August 1, 7:05 PM ET
  def parse_date(str)
    str.gsub!('ET', 'EDT')
    DateTime.strptime(str, '%B %d, %I:%M %p %Z')
  end

  def date_to_str(date)
    date.strftime('%B %-d')
  end

end


