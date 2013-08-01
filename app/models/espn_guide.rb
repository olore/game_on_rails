#require 'nokogiri'

class ESPNGuide
  STATIONS = %w( MLBN FOX TBS ESPN )

  def self.games_for(doc, station)
    games = []
    doc.xpath("//table/tr[td//text()[contains(., '#{station}')]]").each do |thing|
      date_time = thing.at_xpath('td[1]').text
      teams = thing.at_xpath('td[2]').text
      games << teams
    end
    games
  end

end


