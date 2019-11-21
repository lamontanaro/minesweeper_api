class UpdateGameService

  def initialize(game, x, y)
    @game = game
    @board = @game.board
    @x = x
    @y = y
  end

  def play
    play_turn while @game.in_progress?

    if @game.lost?
      puts 'game over'
    elsif @game.won?
      winning_board = show_flags_on_winning_board(@board.visible_board)
    end
  end

  private

  def play_turn
    guess = CoordinatePair.new(@x, @y)

    @game.game_lost = true if @game.mine?(guess)
    @game.reveal_guess(guess, @board.visible_board)
  end

  def show_flags_on_winning_board
    flag_mines_board = @board.map do |array|
      array.map { |cell| cell == BoardService::HIDDEN_CELL ? BoardService::MINE_FLAG : cell }
    end
  end

end
