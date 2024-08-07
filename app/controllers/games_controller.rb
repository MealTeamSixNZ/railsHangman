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
    @display_word = get_display_word(@secret_word)

    set_flash
  end

  def update
    @game = Game.find(params[:id])
    @letter = params[:letter]

    if @game.guesses.exclude?(@letter)
      @game.guesses << @letter
    end

    secret_word = @game.gameword
    if !secret_word.include?(@letter) # Should this be unless? Finding unless statements pretty confusing.
      @game.lives -= 1
    end

    set_flash

    if @game.save
      redirect_to game_path(@game)
    else
      render :show, status: :bad_request
    end
  end

  def create
    game_settings = game_params
    difficulty = Integer(game_settings[:difficulty])
    game_settings.delete(:difficulty)
    @game = Game.new(game_settings)
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
    params.require(:game).permit(:player, :lives, :guesses, :difficulty)
  end

  def set_lives(difficulty)
    if difficulty == 1
      @game.lives = 13
    elsif difficulty == 2
      @game.lives = 10
    else
      @game.lives = 7
    end
  end

  def set_gameword(difficulty)
    @game.gameword = word_fetcher(difficulty).word
  end

  def get_display_word(secret_word)
    if has_lost
      secret_word
    else
      word_replacer(secret_word)
    end
  end

  def word_replacer(secret_word)
    secret_word.chars.map do |letter|
      @game.guesses.include?(letter) ? letter : '_ '
    end.join
  end

  def has_won
    secret_word = @game.gameword
    updated_word = word_replacer(secret_word)
    updated_word == secret_word
  end
  def has_lost
    @game.lives <= 0
  end

  def set_flash
    if has_won
      flash[:notice] = 'You have won! GG'
    elsif has_lost
      flash[:notice] = 'You have lost, better luck next time'
    else
      flash[:notice] = ""
    end
  end
end