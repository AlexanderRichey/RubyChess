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
    self[[0, 0]] = Piece.new
  end

  def move(start, end_pos)
    if self[start].nil?
      raise BoardError.new("No chess-piece there.")
    end

    # error for invalid move

    piece = self[start]
    self[start] = nil
    self[end_pos] = piece
  end
end
