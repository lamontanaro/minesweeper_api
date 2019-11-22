require 'rails_helper'

RSpec.describe 'BoardService', :type => :request do

  it 'Empty visible board' do
    board = BoardService.new

    hide_row_count = board.visible_board.flatten.count(BoardService::HIDDEN_CELL)

    expect(hide_row_count).to be(BoardService::TOTAL_CELLS)
  end

  context 'Generate Mine board' do
    it 'Board with 10 mines' do
      board = BoardService.new

      mine_count = board.mine_board.flatten.count(BoardService::MINE)

      expect(mine_count).to be(10)
    end
  end

end
