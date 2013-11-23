class GamesController < ApplicationController
  respond_to :json

  def for_date
    selected_date = Date.parse(params[:date])
    games = Game.where(:date => selected_date.beginning_of_day..selected_date.end_of_day)
    respond_with games
  end

  def for_station
    games = Game.where(station: params[:station]).order(:date)
    respond_with games
  end

  private

end
