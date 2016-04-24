class Knight < SteppingPiece
  def initialize(board, pos, color)
    super(board, pos, color)
    @value = 3
  end

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
