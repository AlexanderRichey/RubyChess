require 'byebug'
require_relative 'evaluator'

class Board
  attr_reader :board

  def initialize(game, board = (Array.new(8) { Array.new(8) }), new_game = true)
    @new_game = new_game
    @board = board

    populate_board if @new_game
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
    if self[start].nil?
      raise BoardError.new("No chess-piece there.")
    end

    unless self[start].valid_moves.include?(end_pos)
      raise BoardError.new("Invalid move.")
    end

    check_check(start, end_pos, true)
    make_move(start, end_pos, self[start])
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

        moves = piece.valid_moves
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
    color = start_piece.color
    currently_in_check = in_check?(color)

    make_move(start, end_pos, start_piece)

    if in_check?(color)
      undo_move(start, end_pos, start_piece, end_piece)

      if currently_in_check
        raise BoardError.new("Must move out of check.")
      else
        raise BoardError.new("Can't move into check.")
      end
    end

    if just_checking
      undo_move(start, end_pos, start_piece, end_piece)
    end

    false
  end

  def valid_moves(color)
    moves = Hash.new { Array.new }

    board.each do |row|
      row.each do |piece|
        next if piece.nil? || piece.color != color

        valid_moves = piece.valid_moves
        next if valid_moves.empty?

        moves[piece] =
          valid_moves.select { |move| ok_move?(piece.pos, move) }
      end
    end

    moves
  end

  def ok_move?(start_pos, end_pos)
    begin
      check_check(start_pos, end_pos, true)
    rescue BoardError
      return false
    end
    true
  end

  def pieces(color)
    pieces = []

    board.each do |row|
      row.each do |piece|
        if piece.nil? || piece.color != color
          next
        else
          pieces << piece
        end
      end
    end

    pieces
  end

  def score(color)
    Evaluator.new(self, color).evaluate
  end

  def make_move(start_pos, end_pos, piece)
    self[start_pos] = nil
    self[end_pos] = piece
    piece.pos = end_pos
  end

  def opponent_color(color)
    color == :white ? :black : :white
  end

  def undo_move(start_pos, end_pos, start_piece, end_piece)
    self[start_pos] = start_piece
    self[end_pos] = end_piece
    start_piece.pos = start_pos
  end

  def deep_dup
    Board.new(nil, self.board.deep_dup, false)
  end

  private
  def populate_board
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
end

class Array
  def deep_dup
    self.inject([]) do |dup, el|
      dup << (el.is_a?(Array) ? el.deep_dup : (el.nil? ? nil : el.dup) )
    end
  end
end

class BoardError < StandardError
end
