class SlidingPiece < Piece

  def move_dirs
    raise
  end

  def valid_moves(all_moves = false)
    output = []

    move_dirs.each do |(d_row, d_col)|
      current_row, current_col = pos

      loop do
        possible_pos = [(current_row += d_row), (current_col += d_col)]
        if @board.in_bounds?(possible_pos) && valid?(pos, possible_pos, all_moves)
          output << possible_pos
          break if @board[possible_pos].is_a?(Piece)
        else
          break
        end
      end
    end

    output
  end
end
