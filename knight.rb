class Knight < SteppingPiece
  def symbol
    " ♞ "
  end

  def move_dirs
    return [[-1, 2],
            [1, 2],
            [1, -2],
            [-1, -2],
            [-2, -1],
            [2, 1],
            [-2, 1],
            [2, -1]]
  end
end
