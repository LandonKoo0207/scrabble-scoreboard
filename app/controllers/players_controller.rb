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

  def cal_word(word)
    word = word.upcase
    score = {'A':1, 'B':3, 'C':3, 'D':2, 'E':1, 'F':4, 'G':2, 'H':4, 'I':1, 'J':8, 'K':5, 'L':1, 'M':3, 'N':1, 'O':1, 'P':3, 'Q':10,'R':1,'S':1,'T':1,'U':1,'V':4,'W':4,'X':8,'Y':4,'Z':10}
    s = 0
    word.each_char do |c|
      s += score[c.to_sym]
    end
    s
  end
end
