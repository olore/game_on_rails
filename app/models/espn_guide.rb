
class ESPNGuide
  STATIONS = %w( MLBN FOX TBS ESPN )

  def self.games_for(doc, station)
    games = []
    doc.xpath("//table/tr[td//text()[contains(., '#{station}')]]").each do |thing|
      date_time = thing.at_xpath('td[1]').text
      teams = thing.at_xpath('td[2]').text
      away, home = parse_home_away_teams(teams)

      games << Game.new(:date => date_time, :home_team => home, :away_team => away)
    end
    games
  end

  #private ?

  def self.parse_home_away_teams(teams)
    if teams =~ /<a href/
      away = teams.match(/<a.*>(.*?)<\/a> @ /)
      home = teams.match(/@ <a.*>(.*?)<\/a>/)
    else
      away = teams.match(/(.*?) @ /)
      home = teams.match(/.*@ (.*?)$/)
    end

    return away[1], home[1]
  end

end


