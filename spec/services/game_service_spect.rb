require 'rails_helper'

RSpec.describe 'GameService', :type => :request do

  it 'when the player won the game' do
    game_win = FactoryBot.create(:game_win)

    game = GameService.new
    game.board.visible_board = game_win.visible_board
    game.board.mine_board = game_win.mine_board

    expect(game.won?).to be(true)
  end

  it "when the player didn't win the game" do
    game_win = FactoryBot.create(:game)

    game = GameService.new
    game.board.visible_board = game_win.visible_board
    game.board.mine_board = game_win.mine_board

    expect(game.won?).to be(false)
  end

  it 'Game in progress' do
    mew_game = FactoryBot.create(:game)

    game = GameService.new
    game.board.visible_board = mew_game.visible_board
    game.board.mine_board = mew_game.mine_board

    expect(game.in_progress?).to be(true)
  end

  it "when the player didn't win the game" do
    game_win = FactoryBot.create(:game_win)

    game = GameService.new
    game.board.visible_board = game_win.visible_board
    game.board.mine_board = game_win.mine_board

    expect(game.in_progress?).to be(false)
  end

  it "when the player touch a mine" do
    new_game = FactoryBot.create(:game)

    game = GameService.new
    game.board.visible_board = new_game.visible_board
    game.board.mine_board = new_game.mine_board
    guest = CoordinatePair.new(7, 1) 

    expect(game.mine?(guest)).to be(true)
  end

  it "when the player touch a mine" do
    new_game = FactoryBot.create(:game)

    game = GameService.new
    game.board.visible_board = new_game.visible_board
    game.board.mine_board = new_game.mine_board
    guest = CoordinatePair.new(1, 1)

    expect(game.mine?(guest)).to be(false)
  end

  it "Reveal item in the game board" do
    new_game = FactoryBot.create(:game)
    game_service = GameService.new
    game_service.board.visible_board = new_game.visible_board
    game_service.board.mine_board = new_game.mine_board
    guess = CoordinatePair.new(1, 1)

    expect(game_service.reveal_guess(guess, new_game.visible_board)).to be(1)
  end

  it "Reveal mine in the game board" do
    new_game = FactoryBot.create(:game)
    game_service = GameService.new
    game_service.board.visible_board = new_game.visible_board
    game_service.board.mine_board = new_game.mine_board
    guess = CoordinatePair.new(7, 1)

    expect(game_service.reveal_guess(guess, new_game.visible_board)).to eq('x')
  end

end
