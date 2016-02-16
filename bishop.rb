class Bishop < SlidingPiece
  def symbol
    " ♝ "
  end

  private
  
  def move_dirs
    return [[-1, -1],
            [-1, 1],
            [1, -1],
            [1, 1]]
  end
end
