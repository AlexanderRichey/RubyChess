class King < SteppingPiece
  def symbol
    " ♚ "
  end

  def move_dirs
    return [[-1, -1],
            [-1, 0],
            [-1, 1],
            [0, -1],
            [0, 1],
            [1, -1],
            [1, 0],
            [1, 1]]
  end
end
