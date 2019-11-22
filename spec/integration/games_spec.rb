# spec/integration/pets_spec.rb
require 'swagger_helper'

describe 'Game API' do

  path '/games' do

    post 'Create game' do
      tags 'Games'
      consumes 'application/json'

      response '200', 'game created' do
        let(:game) { FactoryBot.create(:game) }
        run_test!
      end

      response '500', 'error' do
        run_test!
      end
    end
  end

  path '/games/{id}' do

    patch 'Send coordinates' do
      tags 'Games'
      produces 'application/json'
      parameter name: :id, :in => :path, :type => :integer
      parameter name: :x, :in => :path, :type => :integer
      parameter name: :y, :in => :path, :type => :integer

      response '200', 'id found' do
        schema type: :object,
          properties: {
            id: { type: :integer, },
            visible_board: { type: :text },
            mine_board: { type: :text },
            game_lost: { type: :boolean }
          },
          required: [ 'id', 'name', 'status' ]

        let(:id) { FactoryBot.create(:game).id }
        run_test!
      end

      response '404', 'Game not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end