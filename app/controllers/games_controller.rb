class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)

    if @game.save
      redirect_to @game
    else
      render :new, status: :bad_request
    end

    set_lives(difficulty)

  end

  private
  def game_params
    params.require(:game).permit(:player, :difficulty)
  end

  def set_lives(difficulty)
    if difficulty == 1
      lives = 14
    elsif difficulty == 2
      lives = 11
    else difficulty == 3
      lives = 7
    end
  end

end
