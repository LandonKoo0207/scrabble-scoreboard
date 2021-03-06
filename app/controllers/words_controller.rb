# frozen_string_literal: true

class WordsController < ApplicationController
  before_action :set_player
  before_action :set_word, only: [:edit, :update, :destroy]
  before_action :set_scrabble

  def create
    if @scrabble.word_possible(params[:word][:word], params[:word][:existing_letter])
      @word = @player.words.create(word_params)

      if @word.valid?
        @word.calculate_score
      end

      @word.skip_validations = params[:pass].present?

      if @word.save
        if params[:num_of_words_passed].length == 0
          next_turn(params[:num_of_words])
        else
          next_turn(params[:num_of_words_passed])
        end

        @scrabble.take_letters_for_word(@word[:word], @word[:existing_letter])
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
    redirect_to scrabble_path(@scrabble, num_of_words_passed: @num_of_words_passed)
  end

  def edit
  end

  def update
    @scrabble.put_back_word(params[:old_word], params[:old_existing_letter])

    if @scrabble.word_possible(params[:word][:word], params[:word][:existing_letter])
      if params[:existing_letter].nil?
          @word[:existing_letter] = []
      end

      if @word.update(word_params)
        @scrabble.take_letters_for_word(@word[:word], @word[:existing_letter])
        
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

  def destroy
    @word.destroy
    flash[:success] = "The word has been delete successfully."
    redirect_to scrabble_path(@scrabble)
  end

  def next_turn(num_of_words_passed)
    if num_of_words_passed.to_i > 1
      @num_of_words_passed = num_of_words_passed.to_i - 1
    else
      @scrabble.new_current_player(@player.id)
     end
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
