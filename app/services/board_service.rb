class BoardService

  BOARD_SIZE = 10 # square
  MINE = 'x'
  MINE_FLAG = '⚑'
  HIDDEN_CELL = '⬜'
  TOTAL_CELLS = BOARD_SIZE * BOARD_SIZE
  EMPTY_CELL = '•'
  EASY_LEVEL = BOARD_SIZE - 1

  def initialize
    @visible_board = generate_clean_grid
    @mine_board = generate_grid_with_mines(@visible_board)
  end

  def generate_clean_grid
    Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE, HIDDEN_CELL) }
  end

  def generate_grid_with_mines(nested_array)
    nested_array.map do |array|
      random_number = generate_random_number
      array.each_with_index.map { |value, key| random_number == key ? MINE : HIDDEN_CELL }
    end
  end

  attr_accessor :mine_board, :visible_board

  private

  def generate_random_number
    Random.new.rand(0...EASY_LEVEL)
  end

end
