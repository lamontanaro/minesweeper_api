class GamesController < ApplicationController

  before_action :start_game, only: [:create, :update]
  before_action :set_game, only: [:update]

  def create
    game = Game.new(visible_board: @board.visible_board, mine_board: @board.mine_board)

    if game.save
      render json: game, status: :ok, adapter: :json
    else
      render json: { error: true, message: game.errors }, status: 500, adapter: :json
    end
  end

  def update
    unless @my_game.game_lost
      message = UpdateGameService.new(@my_game, @game, params[:x], params[:y]).play

      render json: { message: message, game: @game }, status: :ok, adapter: :json
    else
      render json: { message: "game over, you can't make more movements", game: @game }, status: :ok, adapter: :json
    end
  end

  private

  def start_game
    @game = GameService.new
    @board = @game.board
  end

  def set_game
    @my_game = Game.find params[:id]
    @board.visible_board = @my_game.visible_board
    @board.mine_board = @my_game.mine_board
  rescue ActiveRecord::RecordNotFound
    render json: { error: true, message: 'Record Not Found' }, status: 404, adapter: :json
  end

end
