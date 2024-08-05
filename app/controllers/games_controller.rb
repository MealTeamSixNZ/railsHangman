class GamesController < ApplicationController
  include SecretWord

  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end

  def new
    @game = Game.new(lives: 0, guesses:'')
  end

  # def update
  #   @game = Game.find(params[:id])
  #
  # end

  def update
    @game = Game.find(params[:id])
    @letter = params[:letter]
    # @game = Game.guesses.push(letter)
    if @game.guesses.exclude?(@letter)
      @game.guesses += @letter
    end

    if @game.save
      if @game.gameword { |letter| @game.gameword.include?(letter)}
      redirect_to game_path(@game), notice: 'You guessed correctly.'
      else
        redirect_to game_path(@game), notice: 'You guessed incorrectly'
      end
    else
      render :show, status: :bad_request
    end
  end

  def create
    @game = Game.new(game_params)
    difficulty = Integer(params.require(:game).permit(:difficulty)[:difficulty])
    set_lives(difficulty)
    set_gameword(difficulty)

    if @game.save
      redirect_to @game
    else
      render :new, status: :bad_request
    end
  end

  private
  def game_params
    params.require(:game).permit(:player, :lives, :guesses)
  end

  def set_lives(difficulty)
    if difficulty == 1
      @game.lives = 14
    elsif difficulty == 2
      @game.lives = 11
    else
      @game.lives = 7
    end
  end

  def set_gameword(difficulty)
    @game.gameword = word_fetcher(difficulty).word
  end

end
