class GameController < ApplicationController
  def index
    @games = Game.all
  end

  def play
    @game = Game.find(params[:id])
  end
end
