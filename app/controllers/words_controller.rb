class WordsController < ApplicationController
  before_action :set_player
  before_action :set_word, only: [:update]

  def create
    puts "params: #{params}"
    if word_possible
      @word = @player.words.create(word_params)

      if @word.valid?
        @word.calculate_score
      end

      if params[:pass].present?
        @word.skip_validations = true
      else
        @word.skip_validations = false
      end

      if @word.save
        flash[:success] = "New Word has been entered successfully."
        s = Scrabble.find(@player.scrabble_id)
        s.set_current_player(@player.id)
        s.save
      else
        flash[:warning] = "New word couldn't be created. Try again."
      end
    else
      flash[:warning] = "There are not enough letters remaining to make up the word. Try again."
    end

    redirect_to scrabble_path(@player.scrabble_id)
  end

  def word_possible
    word_in_hash = Hash[params[:word][:word].split('').group_by{ |c| c }.map{ |key, value| [key, value.size] }]
    scrabble = Scrabble.find(@player.scrabble_id)
    word_in_hash.each do |letter, count|
      if count > scrabble.remaining_letters[letter.upcase.to_sym]
        return false
      else
        scrabble.remaining_letters[letter.upcase.to_sym] -= count
        scrabble.save
      end
    end
    true
  end

  def put_back_word(word)
    word_in_hash = Hash[word.split('').group_by{ |c| c }.map{ |key, value| [key, value.size] }]
    scrabble = Scrabble.find(@player.scrabble_id)
    word_in_hash.each do |letter, count|
      scrabble.remaining_letters[letter.upcase.to_sym] += count
    end
    scrabble.save
  end

  def edit
  end

  def update
    if word_possible
      put_back_word(params[:old_word])
      @word.update(word_params)
    else
      flash[:warning] = "There are not enough letters remaining to make up the word. Try again."
    end
    redirect_to scrabble_path(@player.scrabble_id)
  end

  private
  def set_player
    @player = Player.find(params[:player_id])
  end

  def word_params
    params.require(:word).permit!
  end

  def set_word
    @word = @player.words.find(params[:id])
  end
end
