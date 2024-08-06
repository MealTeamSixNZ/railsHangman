namespace :import do
  task dictionary: :environment do
    require 'open-uri'
    open('/home/flynn/hangman_game/public/dict.txt') do |file|
      file.each_line do |line|
        word = line.strip.upcase
        difficulty = case word.length
                     when 1..5 then 1 # Easy
                     when 6..8 then 2 # Regular
                     else 3         # Hard
                     end
        Dictionary.create!(word: word, difficulty: difficulty)
      end
    end
    puts "Import completed!"
  end
end
