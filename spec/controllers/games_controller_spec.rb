require "rails_helper"

RSpec.describe GamesController, type: :request do

  context "post gameController" do
    it "creating new game" do
      expect { post "/games" }.to change { Game.count }.by(1)
    end
  end

  context "Put gameController" do
    it "Send rigth coordinates" do
      new_game = FactoryBot.create(:game)
      previous_visible_board = new_game.visible_board

      put "/games/#{new_game.id}", params: {x: 1, y:1}

      new_visible_board = Game.find(new_game.id).visible_board
      previous_hide_cell_count = previous_visible_board.flatten.count(BoardService::HIDDEN_CELL)
      new_hide_cell_count = new_visible_board.flatten.count(BoardService::HIDDEN_CELL)

      expect(response).to have_http_status(200)
      expect(previous_hide_cell_count).to be > (new_hide_cell_count)
    end

    it "Sent request to the ended game" do
      new_game = FactoryBot.create(:game_over)

      put "/games/#{new_game.id}", params: {x: 1, y:1}

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['message']).to eq("game over, you can't make more movements")
    end

    it "Sent unexisted game id" do
      put "/games/#{5}", params: {x: 1, y:1}

      expect(response).to have_http_status(404)
    end
  end

end
