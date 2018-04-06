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

    @scrabble.remaining_letters = {'A':9, 'B':2, 'C':2, 'D':4, 'E':12, 'F':2, 'G':3, 'H':2, 'I':9, 'J':1, 'K':1, 'L':4, 'M':2, 'N':6, 'O':8, 'P':2, 'Q':1,'R':6,'S':4,'T':6,'U':4,'V':2,'W':2,'X':1,'Y':2,'Z':1}

    if @scrabble.save
      flash[:success] = "Let's play Scabble!"
      redirect_to new_scrabble_player_path(@scrabble.id)
    else
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
