class Game

  attr_reader :teams, :date

  def initialize(hash)
    @teams = hash[:teams]
    @date = hash[:date]
  end

end

