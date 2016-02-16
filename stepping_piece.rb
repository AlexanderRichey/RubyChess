class SteppingPiece < Piece

  def move_dirs
    raise
  end

  def valid_moves(all_moves = false)
    output = []

    move_dirs.each do |(d_row, d_col)|
      current_row, current_col = pos
      possible_pos = [(current_row += d_row), (current_col += d_col)]

      if @board.in_bounds?(possible_pos) && @board.valid?(pos, possible_pos, all_moves)
        output << possible_pos
      end
    end

    output
  end
end
