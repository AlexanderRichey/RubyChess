class Bishop < SlidingPiece
  def symbol
    " ♝ "
  end

  def move_dirs
    return [[-1, -1],
            [-1, 1],
            [1, -1],
            [1, 1]]
  end
end
