class BoardError < StandardError

end

class Board
  attr_reader :board

  def initialize
    @board = Array.new(8) { Array.new(8) }

    populate_board
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @board[row][col] = value
  end

  def populate_board #place pieces
    self[[0, 4]] = King.new(self, [0, 4])
    self[[0, 3]] = Queen.new(self, [0, 3]) # black
    self[[0, 2]] = Bishop.new(self, [0, 2])
    self[[0, 5]] = Bishop.new(self, [0, 5])
    self[[0, 0]] = Rook.new(self, [0,0])
    self[[0, 7]] = Rook.new(self, [0,7])
    self[[0, 1]] = Knight.new(self, [0, 1])
    self[[0, 6]] = Knight.new(self, [0, 6])

    self[[7, 4]] = King.new(self, [7, 4])
    self[[7, 3]] = Queen.new(self, [7, 3]) # white
    self[[7, 2]] = Bishop.new(self, [7, 2])
    self[[7, 5]] = Bishop.new(self, [7, 5])
    self[[7, 0]] = Rook.new(self, [7,0])
    self[[7, 7]] = Rook.new(self, [7,7])
    self[[7, 1]] = Knight.new(self, [7, 1])
    self[[7, 6]] = Knight.new(self, [7, 6])
  end

  def move(start, end_pos)
    # Check to see if there as a piece to be selected
    if self[start].nil?
      raise BoardError.new("No chess-piece there.")
    end

    # Grab piece
    piece = self[start]

    # Check whether piece moves that way
    unless piece.valid_moves.include?(end_pos)
      raise BoardError.new("Invalid move.")
    end

    # Reset start, update positions on board AND piece
    self[start] = nil
    self[end_pos] = piece
    piece.pos = end_pos
  end

  def in_bounds?(pos)
    pos.each do |coord|
      return false if coord < 0 || coord >= @board.length
    end

    true
  end

  def open?(pos)
    self[pos].nil? ? true : false
  end
end
