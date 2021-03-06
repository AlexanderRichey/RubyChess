class Pawn < Piece
  attr_reader :direction

  def initialize(board, pos, direction, color)
    super(board, pos, color)
    @original_position = pos.dup
    @direction = direction
    @value = 1
  end

  def symbol
    " ♟ "
  end

  def valid_moves
    output = []

    move_dirs.each do |(d_row, d_col)|
      current_row, current_col = pos
      possible_pos = [(current_row += d_row), (current_col += d_col)]

      if @board.in_bounds?(possible_pos) && valid_pawn_move?(pos, possible_pos)
        output << possible_pos
      end
    end

    output
  end

  def valid_pawn_move?(pos, possible_pos)
    return true if @board[pos].nil?

    if @board[possible_pos].nil?
      return (
        !diagonal_move?(pos, possible_pos) &&
        !en_passant?(pos, possible_pos)
      )
    elsif @board[possible_pos].color == @board[pos].opponent_color &&
      diagonal_move?(pos, possible_pos)
        return true
    else
      return false
    end
  end

  private

  def diagonal_move?(org_pos, des_pos)
    row, col = org_pos
    d_row, d_col = des_pos

    row -= d_row
    col -= d_col

    return row.abs == 1 && col.abs == 1
  end

  def en_passant?(org_pos, des_pos)
    if (org_pos[0] - des_pos[0]).abs == 2
      if @board[[(org_pos[0] + direction), org_pos[1]]].nil?
        return false
      else
        return true
      end
    else
      return false
    end
  end

  def move_dirs
    output = [[direction, 0], [direction, -1], [direction, 1]]

    output << [(direction * 2), 0] if @pos == @original_position

    output
  end
end
