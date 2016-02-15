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
    self[[0, 4]] = King.new(self, [0, 4], :black)
    self[[0, 3]] = Queen.new(self, [0, 3], :black) # black
    self[[0, 2]] = Bishop.new(self, [0, 2], :black)
    self[[0, 5]] = Bishop.new(self, [0, 5], :black)
    self[[0, 0]] = Rook.new(self, [0,0], :black)
    self[[0, 7]] = Rook.new(self, [0,7], :black)
    self[[0, 1]] = Knight.new(self, [0, 1], :black)
    self[[0, 6]] = Knight.new(self, [0, 6], :black)
    self[[1, 0]] = Pawn.new(self, [1, 0], 1, :black)
    self[[1, 1]] = Pawn.new(self, [1, 1], 1, :black)
    self[[1, 2]] = Pawn.new(self, [1, 2], 1, :black)
    self[[1, 3]] = Pawn.new(self, [1, 3], 1, :black)
    self[[1, 4]] = Pawn.new(self, [1, 4], 1, :black)
    self[[1, 5]] = Pawn.new(self, [1, 5], 1, :black)
    self[[1, 6]] = Pawn.new(self, [1, 6], 1, :black)
    self[[1, 7]] = Pawn.new(self, [1, 7], 1, :black)

    self[[7, 4]] = King.new(self, [7, 4], :white)
    self[[7, 3]] = Queen.new(self, [7, 3], :white) # white
    self[[7, 2]] = Bishop.new(self, [7, 2], :white)
    self[[7, 5]] = Bishop.new(self, [7, 5], :white)
    self[[7, 0]] = Rook.new(self, [7,0], :white)
    self[[7, 7]] = Rook.new(self, [7,7], :white)
    self[[7, 1]] = Knight.new(self, [7, 1], :white)
    self[[7, 6]] = Knight.new(self, [7, 6], :white)
    self[[6, 0]] = Pawn.new(self, [6, 0], -1, :white)
    self[[6, 1]] = Pawn.new(self, [6, 1], -1, :white)
    self[[6, 2]] = Pawn.new(self, [6, 2], -1, :white)
    self[[6, 3]] = Pawn.new(self, [6, 3], -1, :white)
    self[[6, 4]] = Pawn.new(self, [6, 4], -1, :white)
    self[[6, 5]] = Pawn.new(self, [6, 5], -1, :white)
    self[[6, 6]] = Pawn.new(self, [6, 6], -1, :white)
    self[[6, 7]] = Pawn.new(self, [6, 7], -1, :white)
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

  def valid?(pos, possible_pos)
    if self[possible_pos].nil?
      return true
    elsif self[possible_pos].color == self[pos].opponent_color
      return true
    else
      return false
    end
  end

  def valid_pawn_move?(pos, possible_pos)
    if self[possible_pos].nil?
      return !diagonal_move?(pos, possible_pos)
    elsif self[possible_pos].color == self[pos].opponent_color && diagonal_move?(pos, possible_pos)
      return true
    else
      return false
    end
  end

  def diagonal_move?(org_pos, des_pos)
    row, col = org_pos
    d_row, d_col = des_pos

    row -= d_row
    col -= d_col

    return row.abs == 1 && col.abs == 1
  end
end
