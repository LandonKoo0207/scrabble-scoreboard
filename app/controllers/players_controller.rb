class PlayersController < ApplicationController
  def index
    @players = Player.order(:turn).all
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.create(player_params)

    if @player.save
      flash[:success] = "New Player has been created successfully"
      redirect_to root_path
    else
      flash[:warning] = "New Player couldn't be created. Please try again"
      render :new
    end
  end

  private

  def player_params
    params.require(:player).permit(:name, :turn)
  end
end
