class Game

  attr_reader :home_team, :away_team, :date

  def initialize(hash)
    @home_team = hash[:home_team]
    @away_team = hash[:away_team]
    @date = hash[:date]
  end

end

