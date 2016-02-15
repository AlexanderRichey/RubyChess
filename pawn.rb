class Pawn < Piece
  attr_reader :direction

  def initialize(board, pos, direction, color)
    super(board, pos, color)
    @first_move = true
    @direction = direction
  end

  def symbol
    " P "
  end

  def pos=(value)
    @pos = value
    @first_move = false
  end

  def move_dirs
    output = [[direction, 0]]

    output << [(direction * 2), 0] if @first_move

    output += capturable_spaces # capturable_spaces return [] when no capturable_spaces
  end

  def valid_moves
    output = []

    move_dirs.each do |(d_row, d_col)|
      current_row, current_col = pos
      possible_pos = [(current_row += d_row), (current_col += d_col)]

      if @board.in_bounds?(possible_pos) && @board.valid?(pos, possible_pos)
        output << possible_pos
        # caputurability
      end
    end

    output
  end

  def capturable_spaces
    []
  end

end
