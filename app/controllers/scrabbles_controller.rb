class ScrabblesController < ApplicationController
  before_action :set_scrabble, only: [:show]

  def index
    @scrabbles = Scrabble.all
  end

  def new
    @scrabble = Scrabble.new
  end

  def create
    @scrabble = Scrabble.create!(scrabble_params)

    if @scrabble.save
      flash[:success] = "Let's play Scabble!"
      redirect_to new_scrabble_player_path(@scrabble.id)
    else
      flash[:success] = "New Scrabble can't be created. Try again."
      render :new
    end
  end

  def show
    @player = @scrabble.players.find(@scrabble.current_player)
    @new_word = @player.words.build
  end

  def set_current_player(player_id)
    @scrabble[:current_player] = player_id
  end

  private

  def scrabble_params
    params.require(:scrabble).permit(:num_of_players, :current_turn, :current_player, :remaining_letters)
  end

  def set_scrabble
    @scrabble = Scrabble.find(params[:id])
  end
end
