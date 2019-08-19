# frozen_string_literal: true

class ScrabblesController < ApplicationController
  before_action :set_user
  before_action :set_scrabble, only: [:show]

  def index
    @scrabbles = @user.scrabbles.reorder(updated_at: :DESC)
  end

  def new
    @scrabble = Scrabble.new
  end

  def create
    @scrabble = @user.scrabbles.create(scrabble_params)

    if @scrabble.save
      flash[:success] = "Let's play Scrabble!"
      redirect_to new_scrabble_player_path(@scrabble.id)
    else
      @scrabble.errors.each do |name, msg|
        flash[:warning] = "#{msg}"
      end
      render :new
    end
  end

  def show
    @player = @scrabble.players.find(@scrabble.current_player)
    @new_word = @player.words.build
    @num_of_words_passed = params[:num_of_words_passed]
  end

  def set_current_player(player_id)
    @scrabble[:current_player] = player_id
  end

  private

  def scrabble_params
    params.require(:scrabble).permit(:num_of_players, :current_turn, :current_player, :remaining_letters, :user_id)
  end

  def set_scrabble
    @scrabble = Scrabble.find(params[:id])
  end

  def set_user
    @user = current_user
  end
end
