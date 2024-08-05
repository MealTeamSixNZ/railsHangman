class GamesController < ApplicationController
  include SecretWord

  def index
    @games = Game.all
  end

  def new
    @game = Game.new(lives: 0, guesses: '')
  end

  def show
    @game = Game.find(params[:id])
    @secret_word = @game.gameword
    @display_word = @secret_word.chars.map do |letter|
      @game.guesses.include?(letter) ? letter : '_ '
    end.join
  end

  def update
    @game = Game.find(params[:id])
    @letter = params[:letter]

    if @game.guesses.exclude?(@letter)
      @game.guesses << @letter
    end

    secret_word = @game.gameword
    updated_word = secret_word.chars.map do |letter|
      @game.guesses.include?(letter) ? letter : '_ '
    end.join

    if !secret_word.include?(@letter)
      @game.lives -= 1
    end

    if updated_word == secret_word
      flash[:notice] = 'You have won! GG'
    elsif @game.lives <= 0
      flash[:notice] = 'You have lost, better luck next time'
    end

    if @game.save
      redirect_to game_path(@game)
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