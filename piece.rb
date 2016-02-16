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
    @color == :white ? :light_black : :black
  end

  def valid?(pos, possible_pos, all_moves)
    unless all_moves
      return false if @board[pos].color != @board.game.current_player
    end

    if @board[possible_pos].nil?
        return true
      elsif @board[possible_pos].color == @board[pos].opponent_color
        return true
      else
        return false
      end
  end

end
