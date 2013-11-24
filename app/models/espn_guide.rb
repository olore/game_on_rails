require 'open-uri'

class ESPNGuide
  STATIONS = %w( MLBN FOX TBS ESPN )
  if Rails.env.development?
    URL = 'http://localhost:3000/espn.go.com-mlb-television.html'
  else
   #URL = 'http://espn.go.com/mlb/television'
    URL = 'http://game-on-rails.herokuapp.com/espn.go.com-mlb-television.html'
  end

  def self.generate(doc = nil)
    doc = doc || Nokogiri::HTML(open(URL))

    trs = doc.xpath("//table/tr[contains(@class,'evenrow')]")
    trs += doc.xpath("//table/tr[contains(@class,'oddrow')]")
    trs.each do |tr|
      date_td     = tr.at_xpath('td[1]').text
      date_time   = parse_date(date_td)

      teams_td    = tr.at_xpath('td[2]').text
      next if teams_td.match(/at/)
      away, home  = parse_home_away_teams(teams_td)

      station    = tr.at_xpath('td[3]').text
      if img_alt = tr.at_xpath('td[3]/img/@alt')
        station =  img_alt.value
      end
      next if station.blank? || station == 'Postponed'

      Game.create!(date:      date_time,
                   home_team: home,
                   away_team: away,
                   station:   station)
    end
  end


  #private?

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


