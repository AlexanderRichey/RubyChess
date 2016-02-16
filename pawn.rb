class Pawn < Piece
  attr_reader :direction

  def initialize(board, pos, direction, color)
    super(board, pos, color)
    @original_position = pos.dup
    @direction = direction
  end

  def symbol
    " P "
  end

  def pos=(value)
    @pos = value
  end

  def move_dirs
    output = [[direction, 0], [direction, -1], [direction, 1]]

    output << [(direction * 2), 0] if @pos == @original_position

    output += capturable_spaces # capturable_spaces return [] when no capturable_spaces
  end

  def valid_moves(all_moves = false)
    output = []

    move_dirs.each do |(d_row, d_col)|
      current_row, current_col = pos
      possible_pos = [(current_row += d_row), (current_col += d_col)]

      if @board.in_bounds?(possible_pos) && @board.valid_pawn_move?(pos, possible_pos, all_moves)
        output << possible_pos
      end
    end

    output
  end

  def capturable_spaces
    []
  end

end
