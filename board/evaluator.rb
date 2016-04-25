class Evaluator
  def initialize(board, color)
    @board, @color = board, color
  end

  attr_reader :board, :color

  START_VALUE = 39

  def quiesce(alpha, beta)
    stand_pat = self.evaluate

    if stand_pat >= beta
      return beta
    end

    if alpha < stand_pat
      alpha = stand_pat
    end

    board.capture_moves(color).each do |piece, moves|
      moves.each do |end_pos|
        start_pos = piece.pos
        start_piece = piece
        end_piece = board[end_pos]
        board.make_move(start_pos, end_pos, start_piece)

        score = -quiesce(-beta, -alpha)

        board.undo_move(start_pos, end_pos, start_piece, end_piece)

        if score >= beta
          return beta
        end

        if score > alpha
          alpha = score
        end

      end
    end

    return alpha
  end

  def evaluate
    material_value +
    pawn_advancement_value +
    minor_piece_advancement_value +
    major_piece_advancement_value +
    rook_correction
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

  def pawn_advancement_value
    score = 0

    if color === :white
      board.pieces(:white).each do |piece|
        if piece.is_a?(Pawn)
          score += (6 - piece.pos[0]) ** 2

          if (3..6).include?(piece.pos[1]) #center bonus
            score *= 2
          end
        end
      end
    else
      board.pieces(:black).each do |piece|
        if piece.is_a?(Pawn)
          score += (piece.pos[0] - 1) ** 2

          if (3..6).include?(piece.pos[1]) #center bonus
            score *= 2
          end
        end
      end
    end

    (score / 20).ceil
  end

  def major_piece_advancement_value
    score = 0

    if color === :white
      board.pieces(:white).each do |piece|
        if piece.is_a?(Rook) || piece.is_a?(Queen)
          score += (7 - piece.pos[0]) ** 2

          if (3..6).include?(piece.pos[1]) #center bonus
            score *= 2
          end
        end
      end
    else
      board.pieces(:black).each do |piece|
        if piece.is_a?(Rook) || piece.is_a?(Queen)
          score += (piece.pos[0] - 0) ** 2

          if (3..6).include?(piece.pos[1]) #center bonus
            score *= 2
          end
        end
      end
    end

    (score / 40).ceil
  end

  def minor_piece_advancement_value
    score = 0

    if color === :white
      board.pieces(:white).each do |piece|
        if piece.is_a?(Knight) || piece.is_a?(Bishop)
          score += (7 - piece.pos[0]) ** 2

          if (3..6).include?(piece.pos[1]) #center bonus
            score *= 2
          end
        end
      end
    else
      board.pieces(:black).each do |piece|
        if piece.is_a?(Knight) || piece.is_a?(Bishop)
          score += (piece.pos[0] - 0) ** 2

          if (3..6).include?(piece.pos[1]) #center bonus
            score *= 2
          end
        end
      end
    end

    (score / 30).ceil
  end

  def rook_correction
    score = 0

    if color === :white
      board.pieces(:white).each do |piece|
        if piece.is_a?(Rook)
          score -= 10 if piece.pos == [6, 6]
        end
      end
    else
      board.pieces(:black).each do |piece|
        if piece.is_a?(Rook)
          score -= 10 if piece.pos == [0, 1]
        end
      end
    end

    (score).ceil
  end

  def opponent_color(color)
    color == :white ? :black : :white
  end
end
