class Queen < SlidingPiece
  def initialize(board, pos, color)
    super(board, pos, color)
    @value = 9
  end

  def symbol
    " ♛ "
  end

  private

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
