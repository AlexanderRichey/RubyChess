class Bishop < SlidingPiece
  def initialize(board, pos, color)
    super(board, pos, color)
    @value = 3
  end

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
