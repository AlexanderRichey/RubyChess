class BoardError < StandardError

end

class Board
  attr_reader :board, :game

  def initialize(game, board = (Array.new(8) { Array.new(8) }))
    @game = game
    @board = board
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
    populate_back_row(0, :black)
    populate_pawns(1, :black)

    populate_back_row(7, :white)
    populate_pawns(6, :white)
  end

  def populate_back_row(row, color)
    self[[row, 4]] = King.new(self, [row, 4], color)
    self[[row, 3]] = Queen.new(self, [row, 3], color)
    self[[row, 2]] = Bishop.new(self, [row, 2], color)
    self[[row, 5]] = Bishop.new(self, [row, 5], color)
    self[[row, 0]] = Rook.new(self, [row,0], color)
    self[[row, 7]] = Rook.new(self, [row,7], color)
    self[[row, 1]] = Knight.new(self, [row, 1], color)
    self[[row, 6]] = Knight.new(self, [row, 6], color)
  end

  def populate_pawns(row, color)
    direction = (color == :white ? -1 : 1)

    8.times do |col|
      self[[row, col]] = Pawn.new(self, [row, col], direction, color)
    end
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
    check_check(start, end_pos)
    self[start] = nil
    self[end_pos] = piece
    piece.pos = end_pos

    game.switch_players!
  end

  def check_check(start, end_pos, just_checking = false)
    start_piece = self[start]
    end_piece = self[end_pos]

    previous_check = in_check?(game.current_player)

    self[start] = nil
    self[end_pos] = start_piece
    start_piece.pos = end_pos

    if in_check?(game.current_player)
      self[start] = start_piece
      self[end_pos] = end_piece
      start_piece.pos = start
      if previous_check
        raise BoardError.new("Must move out of check.")
      else
        raise BoardError.new("Can't move into check.")
      end
    end

    if just_checking
      self[start] = start_piece
      self[end_pos] = end_piece
      start_piece.pos = start
      return false
    end
  end

  def checkmate?
    checkmate = true

    @board.each do |row|
      row.each do |piece|
        if piece.is_a?(Piece)
          piece.valid_moves.each do |move|
            begin
              checkmate = false unless check_check(piece.pos, move, true)
            rescue BoardError
            end
          end
        end
      end
    end

    checkmate
  end

  def in_bounds?(pos)
    pos.each do |coord|
      return false if coord < 0 || coord >= @board.length
    end

    true
  end

  def valid?(pos, possible_pos, all_moves)
    unless all_moves
      return false if self[pos].color != game.current_player
    end

    if self[possible_pos].nil?
        return true
      elsif self[possible_pos].color == self[pos].opponent_color
        return true
      else
        return false
      end
  end

  def valid_pawn_move?(pos, possible_pos, all_moves)
    unless all_moves
      return false if self[pos].color != game.current_player
    end

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

  def in_check?(color)
    board.each do |row|
      row.each do |piece|
        next if piece.nil?

        moves = piece.valid_moves(true)
        moves.each do |coord|
          return true if self[coord].is_a?(King) && self[coord].color == color
        end
      end
    end

    false
  end
end
