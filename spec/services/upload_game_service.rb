require 'rails_helper'

RSpec.describe 'UpdateGameService', :type => :request do

  it "when dont touch a mine nor win" do
    new_game = FactoryBot.create(:game)
    game_service = GameService.new
    game_service.board.visible_board = new_game.visible_board
    game_service.board.mine_board = new_game.mine_board

    message = UpdateGameService.new(new_game, game_service, 1, 1).play

    expect(message).to be(UpdateGameService::NEXT_MOVEMENT)
  end

  it "when touch a mine" do
    new_game = FactoryBot.create(:game)
    game_service = GameService.new
    game_service.board.visible_board = new_game.visible_board
    game_service.board.mine_board = new_game.mine_board

    message = UpdateGameService.new(new_game, game_service, 7, 1).play

    expect(message).to be(UpdateGameService::GAME_OVER)
  end

end
