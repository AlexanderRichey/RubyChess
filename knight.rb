class Knight < SteppingPiece
  def symbol
    " ♞ "
  end

  private

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
