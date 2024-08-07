class Dictionary < ApplicationRecord

  validates :word, length: { minimum: 3 }, presence: true
  validates :difficulty, numericality: { only_integer: true }, inclusion: 1..3, presence: true
end
