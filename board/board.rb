require_relative '../relatives'

class Board
  attr_reader :board, :turn_count, :game

  def initialize(game, board = (Array.new(8) { Array.new(8) }))
    @game = game
    @board = board
    @turn_count = 0
    @game_over = false
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @board[row][col] = value
  end

  def game_over?
    @game_over = checkmate?
  end

  def move(start_pos, end_pos)
    if self[start_pos].nil?
      raise BoardError.new("There's no piece there.")
    elsif !self[start_pos].valid_moves.include?(end_pos)
      raise BoardError.new("Invalid move.")
    end

    validate_move!(start_pos, end_pos, true)
    make_move!(start_pos, end_pos, self[start_pos])
    @turn_count += 1
  end

  def all_pieces
    all_pieces = []

    board.each do |row|
      all_pieces << row.select do |el|
        el.is_a?(Piece)
      end
    end

    all_pieces.flatten
  end

  def pieces_for(color)
    all_pieces.select { |piece| piece.color == color }
  end

  def checkmate?
    valid_moves(game.current_player.color).values.flatten.empty?
  end

  def checkmate_for?(color)
    self.checkmate? && pieces_for(color).none? { |piece| piece.is_a?(King) }
  end

  def in_bounds?(pos)
    pos.each do |coord|
      return false if coord < 0 || coord >= @board.length
    end

    true
  end

  def in_check?(color)
    all_valid_end_positions.each do |end_pos|
      if self[end_pos].is_a?(King) && self[end_pos].color == color
        return true
      end
    end

    false
  end

  def valid_moves(color)
    moves = Hash.new { Array.new }

    pieces_for(color).each do |piece|
      moves[piece] = piece.valid_moves.select do |end_pos|
        legal_move?(piece.pos, end_pos)
      end
    end

    moves
  end

  def capture_moves(color)
    capture_moves = Hash.new { Array.new }

    valid_moves(color).each do |piece, moves|
      capture_moves[piece] = moves.select do |end_pos|
        capture?(piece.pos, end_pos)
      end
    end

    capture_moves
  end

  def capture?(start_pos, end_pos)
    return false unless self[end_pos].is_a?(Piece)

    if self[end_pos].color != self[start_pos].color
      return true
    else
      return false
    end
  end

  def score(color, alpha, beta)
    Evaluator.new(self, color).quiesce(alpha, beta)
  end

  def make_move!(start_pos, end_pos, piece)
    self[start_pos] = nil
    self[end_pos] = piece
    piece.pos = end_pos

    promote!(end_pos, piece.color) if promotion?(piece, end_pos)
  end

  def undo_move!(start_pos, end_pos, start_piece, end_piece)
    self[start_pos] = start_piece
    self[end_pos] = end_piece
    start_piece.pos = start_pos

    demote!(start_pos, start_piece.color) if promotion?(start_piece, end_pos)
  end

  def opponent_color(color)
    color == :white ? :black : :white
  end

  def populate_board!
    populate_back_row!(0, :black)
    populate_pawns!(1, :black)

    populate_back_row!(7, :white)
    populate_pawns!(6, :white)

    self
  end

  private
  def validate_move!(start_pos, end_pos, just_checking = false)
    start_piece = self[start_pos]
    end_piece = self[end_pos]
    color = start_piece.color
    currently_in_check = in_check?(color)

    make_move!(start_pos, end_pos, start_piece)

    if in_check?(color)
      undo_move!(start_pos, end_pos, start_piece, end_piece)

      if currently_in_check
        raise BoardError.new("Must move out of check.")
      else
        raise BoardError.new("Can't move into check.")
      end
    end

    if just_checking
      undo_move!(start_pos, end_pos, start_piece, end_piece)
    end

    false
  end

  def legal_move?(start_pos, end_pos)
    begin
      validate_move!(start_pos, end_pos, true)
    rescue BoardError
      return false
    end

    true
  end

  def all_valid_end_positions
    end_positions = []

    all_pieces.each do |piece|
      end_positions << piece.valid_moves
    end

    end_positions.flatten(1)
  end

  def promote!(pos, color)
    self[pos] = Queen.new(self, pos, color)
  end

  def demote!(pos, color)
    direction = (color == :white ? -1 : 1)
    self[pos] = Pawn.new(self, pos, direction, color)
  end

  def promotion?(piece, pos)
    piece.is_a?(Pawn) && pos[0] == (piece.color == :black ? 7 : 0)
  end

  def populate_back_row!(row, color)
    self[[row, 4]] = King.new(self, [row, 4], color)
    self[[row, 3]] = Queen.new(self, [row, 3], color)
    self[[row, 2]] = Bishop.new(self, [row, 2], color)
    self[[row, 5]] = Bishop.new(self, [row, 5], color)
    self[[row, 0]] = Rook.new(self, [row,0], color)
    self[[row, 7]] = Rook.new(self, [row,7], color)
    self[[row, 1]] = Knight.new(self, [row, 1], color)
    self[[row, 6]] = Knight.new(self, [row, 6], color)
  end

  def populate_pawns!(row, color)
    direction = (color == :white ? -1 : 1)

    8.times do |col|
      self[[row, col]] = Pawn.new(self, [row, col], direction, color)
    end
  end

  def reset_piece_positions!
    8.times do |row_idx|
      8.times do |col_idx|
        if board[row_idx, col_idx].is_a?(Piece)
          board[row_idx, col_idx].pos = [row_idx, col_idx]
        end
      end
    end
  end

end

class BoardError < StandardError
end
