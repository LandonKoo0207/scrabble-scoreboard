class WordsController < ApplicationController
  before_action :set_player
  before_action :set_word, only: [:update]
  before_action :set_scrabble

  def create
    if @scrabble.word_possible(params[:word])
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
        @scrabble.set_current_player(@player.id)
        @scrabble.take_letters_for_word(@word)
        @scrabble.save
        flash[:success] = "New Word has been entered successfully."
      else
        @word.errors.each do |name, msg|
          flash[:warning] = msg
        end
      end
    else
      flash[:warning] = "There are not enough letters remaining to make up the word. Try again."
    end

    redirect_to scrabble_path(@scrabble)
  end

  def edit
  end

  def update
    @scrabble.put_back_word(params[:old_word])

    if @scrabble.word_possible(params[:word])
      if @word.update(word_params)
        @scrabble.take_letters_for_word(@word)
        @scrabble.save
        flash[:success] = "The word has been updated successfully."
      else
        @word.errors.each do |name, msg|
          flash[:warning] = msg
        end
      end
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

  def set_scrabble
    @scrabble = Scrabble.find(params[:scrabble_id])
  end
end
