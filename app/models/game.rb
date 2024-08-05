class Game < ApplicationRecord
  def guess
    # code here
  end

  def guess(letter)
    if @game.guesses.exclude?(letter)
      if @game.gameword.exclude?(letter)
        @game.lives -1
      end
    end
    @game.guesses.push(letter)
  end

  def has_won
    if @game.guesses.each.include?(@game.gameword)
      true
      render notice: 'You have won! GG'
    end
  end

  def has_lost
    if @game.lives == 0
      true
      render notice: 'You have lost, better luck next time'
    end
  end

  def incorrect_guesses
    incorrect_guesses = @game.guesses { |letter| @game.gameword.exclude?(letter)}
  end

  def correct_guesses
    correct_guesses = @game.guesses { |letter| @game.gameword.include?(letter) }
  end

  #do i need to turn @game.guesses into an array of singular letters everytime I check it?
  # def button_disabler()
  #TOOD do I need to do this or is there a way to do it on the view?
  # what the fuck is unless, it fucked me up

end
