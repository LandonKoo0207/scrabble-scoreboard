class WordsController < ApplicationController
  before_action :set_player

  def create
    @word = @player.words.create(word_params)

    if @word.valid?
      calculate_score(@word[:word])
    end

    if @word.save
      flash[:success] = "New Word has been entered successfully."
      s = Scrabble.find(@player.scrabble_id)
      puts "#{@player.id} #{Player.last.id}"
      if @player == Player.last
        s[:current_player] = 1
      else
        s[:current_player] += 1
      end
      s.save
      puts "words save #{s}"
      redirect_to scrabble_path(@player.scrabble_id)
    else
      flash[:warning] = "New word couldn't be created. Try again."
      render :new
    end
  end

  def calculate_score(word)
    word = word.upcase
    score = {'A':1, 'B':3, 'C':3, 'D':2, 'E':1, 'F':4, 'G':2, 'H':4, 'I':1, 'J':8, 'K':5, 'L':1, 'M':3, 'N':1, 'O':1, 'P':3, 'Q':10,'R':1,'S':1,'T':1,'U':1,'V':4,'W':4,'X':8,'Y':4,'Z':10}
    s = 0
    word.each_char.with_index do |char, i|
      if @word[:double_letter].include? i+1
        s += score[char.to_sym] * 2
      elsif @word[:triple_letter].include? i+1
        s += score[char.to_sym] * 3
      else
        s += score[char.to_sym]
      end
    end

    if @word[:double_word]
      s *= 2
    end

    if @word[:triple_word]
      s *= 3
    end

    @word[:score] = s
  end

  private
  def set_player
    @player = Player.find(params[:player_id])
  end

  def word_params
    params.require(:word).permit!
  end
end
