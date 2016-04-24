class Piece
  attr_reader :color, :value
  attr_accessor :pos

  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
  end

  def display_color
    @color == :white ? :white : :black
  end

  def valid?(start_pos, end_pos)
    return true if @board[start_pos].nil?

    if @board[end_pos].nil?
      return true
    elsif @board[end_pos].color == @board[start_pos].opponent_color
      return true
    else
      return false
    end
  end

  protected

  def opponent_color
    @color == :white ? :black : :white
  end
end
