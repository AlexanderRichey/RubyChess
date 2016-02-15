class Piece
  attr_reader :color
  attr_accessor :pos

  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
  end

  def opponent_color
    @color == :white ? :black : :white
  end

  def display_color
    @color == :white ? :white : :blue
  end

end
