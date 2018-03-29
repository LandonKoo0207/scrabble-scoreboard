class PlayersController < ApplicationController
  before_action :set_scrabble

  def index
    @players = Player.order(:turn).all
  end

  def create
    @players = Player.all
    @player = @scrabble.players.create(player_params)
    
    # When the first player created, make it the initial player for scrabble
    if @players.count == 1
      @scrabble[:current_player] = @player.id
      @scrabble.save
    end

    if @player.save
      flash[:success] = "New Player has been created successfully"
      if @players.count < @scrabble.num_of_players
        render :new
      else
        redirect_to scrabble_path(@scrabble)
      end
    else
      flash[:warning] = "New Player couldn't be created. Please try again"
      render :new
    end
  end

  private

  def player_params
    params.require(:player).permit(:name, :turn, :scrabble_id)
  end

  def set_scrabble
    @scrabble = Scrabble.find(params[:scrabble_id])
  end
end
