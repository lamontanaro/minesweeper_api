class GameService

  WITHOUT_MINE = 0

  def initialize
    @board = BoardService.new
    @game_lost = false
    @empty_cells = []
  end

  attr_accessor :board
  attr_accessor :game_lost

  def won?
    untouched_cells = @board.visible_board.flatten.count(BoardService::HIDDEN_CELL)
    number_of_mines = @board.mine_board.flatten.count(BoardService::MINE)
    untouched_cells == number_of_mines
  end

  def in_progress?
    !(won? || lost?)
  end

  def lost?
    @game_lost
  end

  def mine?(guess)
    coordinates = axis_adjusted_coordinates(guess)

    @board.mine_board[coordinates.y][coordinates.x] == BoardService::MINE
  end

  def reveal_guess(guess, board)
    coordinates = axis_adjusted_coordinates(guess)
    number = number_of_surrounding_mines(coordinates)

    if mine?(guess)
      board[coordinates.y][coordinates.x] = BoardService::MINE
    elsif number == WITHOUT_MINE
      board[coordinates.y][coordinates.x] = BoardService::EMPTY_CELL
      @empty_cells.push(coordinates)
      show_empty_neighbours(coordinates)
    else
      board[coordinates.y][coordinates.x] = number
    end
  end

  private

  def axis_adjusted_coordinates(guess)
    x_value = guess.x - 1
    y_value = BoardService::BOARD_SIZE - (guess.y) # because counting from bottom rather than top
    CoordinatePair.new(x_value, y_value)
  end

  def number_of_surrounding_mines(guess)
    cell_coords = get_surrounding_cell_coords(guess)
    cell_values = get_surrounding_cell_values(cell_coords)
    cell_values.count(BoardService::MINE)
  end

  def get_surrounding_cell_values(array_of_cell_coords)
    cell_values = []

    array_of_cell_coords.each do |cell|
      cell_values.push(@board.mine_board[cell.y][cell.x])
    end

    cell_values
  end

  def get_surrounding_cell_coords(coordinates)
    surrounding_cell_coords = []

    if coordinates.y >= 1                                                                 # up
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x, coordinates.y - 1))
    end

    if coordinates.y < BoardService::BOARD_SIZE - 1                                          # down
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x, coordinates.y + 1))
    end

    if coordinates.x >= 1                                                                 # left
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x - 1, coordinates.y))
    end

    if coordinates.x < BoardService::BOARD_SIZE - 1                                          # right
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x + 1, coordinates.y))
    end

    if coordinates.y >= 1 && coordinates.x >= 1                                                 # top left
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x - 1, coordinates.y - 1))
    end

    if coordinates.y < BoardService::BOARD_SIZE - 1 && coordinates.x >= 1                          # bottom left
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x - 1, coordinates.y + 1))
    end

    if coordinates.y >= 1 && coordinates.x < BoardService::BOARD_SIZE - 1                          # top right
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x + 1, coordinates.y - 1))
    end

    if coordinates.y < BoardService::BOARD_SIZE - 1 && coordinates.x < BoardService::BOARD_SIZE - 1   # bottom right
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x + 1, coordinates.y + 1))
    end

    surrounding_cell_coords
  end

  def show_empty_neighbours(cell)
    neighbour_cells = get_surrounding_cell_coords(cell)

    neighbour_cells.each do |cell|
      next if @empty_cells.include?(cell)
      reveal_neighbours_on_board(cell)
    end
  end

  def reveal_neighbours_on_board(cell)
    cell_value = number_of_surrounding_mines(cell)

    if cell_value == 0
      @empty_cells.push(cell)
      @board.visible_board[cell.y][cell.x] = BoardService::EMPTY_CELL
      show_empty_neighbours(cell)
    else
      @board.visible_board[cell.y][cell.x] = cell_value
    end
  end
end
