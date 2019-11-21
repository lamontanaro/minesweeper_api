class UpdateGameService

  YOU_WIN = 'Win'
  NEXT_MOVEMENT = 'Next movement'
  GAME_OVER = 'Lost'

  def initialize(game_instance, game, x, y)
    @game = game
    @board = @game.board
    @x = x.to_i
    @y = y.to_i
    @game_instance = game_instance
  end

  def play
    play_turn

    if @game.lost?
      GAME_OVER
    elsif @game.won?
      winning_board = show_flags_on_winning_board(@board.visible_board)
      YOU_WIN
    else
      NEXT_MOVEMENT
    end
  end

  private

  def play_turn
    guess = CoordinatePair.new(@x, @y)
    game_over if @game.mine?(guess)
    @game.reveal_guess(guess, @board.visible_board)
    @game_instance.update(visible_board: @board.visible_board)
  end

  def game_over
    @game.game_lost = true
    @game_instance.update(game_lost: true)
  end

  def show_flags_on_winning_board
    flag_mines_board = @board.map do |array|
      array.map { |cell| cell == BoardService::HIDDEN_CELL ? BoardService::MINE_FLAG : cell }
    end
  end

end
