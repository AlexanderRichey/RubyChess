class Evaluator
  def initialize(board, color)
    @board, @color = board, color
  end

  attr_reader :board, :color

  def evaluate
    pieces_value + position_value
  end

  def pieces_value
    score = 0

    board.pieces(color).each do |piece|
      score += piece.value
    end

    board.pieces(opponent_color(color)).each do |piece|
      score -= piece.value
    end

    score
  end

  def position_value
    score = 0

    if color === :black
      board.pieces(color).each do |piece|
        if piece.is_a?(Pawn)
          score += piece.pos[0]
        end
      end

      board.pieces(opponent_color(color)).each do |piece|
        if piece.is_a?(Pawn)
          score -= 7 - piece.pos[0]
        end
      end
    else
      board.pieces(color).each do |piece|
        if piece.is_a?(Pawn)
          score += 7 - piece.pos[0]
        end
      end

      board.pieces(opponent_color(color)).each do |piece|
        if piece.is_a?(Pawn)
          score -= piece.pos[0]
        end
      end
    end

    score
  end

  def opponent_color(color)
    color == :white ? :black : :white
  end
end
