class Evaluator
  def initialize(board, color)
    @board, @color = board, color
  end

  attr_reader :board, :color

  START_VALUE = 39

  def evaluate
    material_value
  end

  def material_value
    score = 0
    board.pieces(color).each do |piece|
      score += piece.value
    end

    opp_score = 0
    board.pieces(opponent_color(color)).each do |piece|
      opp_score += piece.value
    end

    opp_diff = START_VALUE - opp_score

    score + opp_diff
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
