require 'open-uri'

class GamesController < ApplicationController
  VOWELS = %w(A E I O U)
  def new
    # grid_size = 10
    # @letters = []
    # @letters << ('A'..'Z').to_a.sample while @letters.size != grid_size
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @word = (params[:user_word] || '').upcase
    @include = include_letters?(@word, @letters)
    @english_word = english_word?(@word)
  end

  private

  def include_letters?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    wagon_dictionary = JSON.parse(response.read)
    wagon_dictionary['found']
  end
end
