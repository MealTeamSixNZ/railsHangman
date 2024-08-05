module SecretWord
  extend ActiveSupport::Concern

  def word_fetcher(difficulty)
    Dictionary.where(difficulty:difficulty).to_ary.sample
  end
end