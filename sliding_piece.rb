class SlidingPiece < Piece

  def move_dirs
    raise
  end

  def valid_moves
    output = []

    move_dirs.each do |(d_row, d_col)|
      current_row, current_col = pos

      loop do
        possible_pos = [(current_row += d_row), (current_col += d_col)]
        if @board.in_bounds?(possible_pos) && @board.open?(possible_pos)
          output << possible_pos
        else
          # Add capturability
          break
        end
      end
    end

    output
  end
end
