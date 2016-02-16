class BoardError < StandardError

end

class Board
  attr_reader :board, :game

  def initialize(game, board = (Array.new(8) { Array.new(8) }))
    @game = game
    @board = board

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

  def move(start, end_pos)
    # Check to see if there as a piece to be selected
    raise BoardError.new("No chess-piece there.") if self[start].nil?

    # Grab piece
    piece = self[start]

    # Check whether piece moves that way
    raise BoardError.new("Invalid move.") unless piece.valid_moves.include?(end_pos)

    check_check(start, end_pos)
    make_move(start, end_pos, piece)

    game.switch_players!
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

  def check_check(start, end_pos, just_checking = false)
    start_piece = self[start]
    end_piece = self[end_pos]

    previous_check = in_check?(game.current_player.color)

    make_move(start, end_pos, start_piece)

    if in_check?(game.current_player.color)
      undo_move(start, end_pos, start_piece, end_piece)

      if previous_check
        raise BoardError.new("Must move out of check.")
      else
        raise BoardError.new("Can't move into check.")
      end
    end

    undo_move(start, end_pos, start_piece, end_piece) if just_checking

    false
  end

  private

  def make_move(start_pos, end_pos, piece)
    self[start_pos] = nil
    self[end_pos] = piece
    piece.pos = end_pos
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

  def undo_move(start_pos, end_pos, start_piece, end_piece)
    self[start_pos] = start_piece
    self[end_pos] = end_piece
    start_piece.pos = start_pos
  end
end
