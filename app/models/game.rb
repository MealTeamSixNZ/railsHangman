class Game < ApplicationRecord

  validates :player, length: {minimum: 2, maximum: 24 }, format: {with: /\A[ a-zA-Z]+\z/}, presence: true
  validates :lives, numericality: { only_integer: true }, inclusion: 0..13, presence: true
end