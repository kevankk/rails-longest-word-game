require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @score ||= session[:score]
    @score = 0 if @score.nil?
    alphabet = ('A'..'Z').to_a
    random_letters = []
    10.times do
      random_letters << alphabet.sample
    end
    @random_letters = random_letters
  end

  def score
    @score = params[:score].to_i
    @letters_grid = params[:letters]
    @word = params[:word]
    last = @letters_grid.length - 1
    @letters_array = @letters_grid[1..last - 1].gsub("\"", '').split(', ')
    @letters_string = @letters_array.join(' ')
    @word_array = @word.upcase.split('')
    @word_valid = true
    @word_array.each do |word|
      if @letters_array.include?(word)
        ind = @letters_array.index(word)
        @letters_array.delete_at(ind)
      else
        @word_valid = false
        @word_text = "Sorry! #{@word} is not included in #{@letters_string}"
      end
    end

    if @word_valid
      url = "https://wagon-dictionary.herokuapp.com/#{@word}"
      word_response = JSON.parse(open(url).read)
      if word_response['found']
        @word_text = "Congrats! #{@word} is a valid word."
        @score += @word.length
        session[:score] = @score
      else
        @word_text = "Tsk Tsk. #{@word} is not a valid word. Try again next time."
      end
    end
  end
end
