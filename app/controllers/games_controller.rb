class GamesController < ApplicationController

  before_action :start_game, only: [:create]

  def create
    game_info = { msg: 'Game started', boad: @board.visible_board }
    render json: game_info, status: :ok, adapter: :json
  end

  def update
    game_update = UpdateGameService.new(@game, params[:x], params[:y])
    render json: game_update, status: :ok, adapter: :json
  end

  private

  def start_game
    @game = GameService.new
    @board = @game.board
  end

end
