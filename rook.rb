class Rook < SlidingPiece
  def symbol
    " R "
  end

  def move_dirs
    return [[-1, 0],
            [0, -1],
            [0, 1],
            [1, 0]]
  end
end
