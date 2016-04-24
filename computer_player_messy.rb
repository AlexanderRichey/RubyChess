class ComputerPlayer
  attr_reader :color, :board

  STATS = {
    start_time: nil,
    end_time: nil,
    diff: nil,
    evaluations: 0
  }

  def initialize(display, color)
    @board = display.board
    @color = color
    @tree = []
  end

  def stats
    "Completed #{STATS[:evaluations]} evaluations in #{STATS[:diff]} seconds."
  end

  def make_a_move(&prc)
    STATS[:evaluations] = 0
    STATS[:start_time] = Time.now

    best_move = evaluate_moves

    STATS[:end_time] = Time.now
    STATS[:diff] = STATS[:end_time] - STATS[:start_time]

    if best_move.nil?
      debugger
    end

    board.move(best_move[:start_pos], best_move[:end_pos])

    File.open('log.txt', 'a') do |log|
      log.puts "Completed #{STATS[:evaluations]} evaluations in #{STATS[:diff]} seconds."
    end

    prc.call
  end

  def to_s
    @color.to_s
  end

  private

  SIGN = {
    white: -1,
    black: 1
  }

  INVERSE_SIGN = {
    :"-1" => :white,
    :"1" => :black
  }

  MAX_DEPTH = 3

  def negamax(board_node, depth, sign, alpha, beta, init_start_pos, init_end_pos)
    if depth == MAX_DEPTH
      return {
        score: sign * board_node.score(INVERSE_SIGN[sign.to_s.to_sym]),
        start_pos: init_start_pos,
        end_pos: init_end_pos
      }
    end

    alpha_start_pos, alpha_end_pos = nil, nil

    board_node.valid_moves(color).each do |piece, moves|
      moves.each do |end_pos|
        start_pos = piece.pos

        duped_board = board_node.deep_dup
        duped_piece = duped_board[start_pos]

        duped_board.make_move(start_pos, end_pos, duped_piece)
        negamax_node = negamax(
          duped_board,
          depth + 1,
          (sign * -1),
          (alpha * 1),
          (beta * 1),
          start_pos,
          end_pos
        )

        STATS[:evaluations] += 1

        if negamax_node[:score] >= beta
          return {
            score: beta,
            start_pos: start_pos,
            end_pos: end_pos
          }
        end

        if negamax_node[:score] > alpha
          alpha = negamax_node[:score]
          alpha_start_pos = start_pos
          alpha_end_pos = end_pos
        end

      end
    end

    return {
      score: alpha,
      start_pos: alpha_start_pos || init_start_pos,
      end_pos: alpha_end_pos || init_end_pos
    }
  end

  def evaluate_moves
    duped_board = board.deep_dup
    best_move = negamax(
      duped_board,
      0,
      SIGN[color],
      -Float::INFINITY,
      Float::INFINITY,
      nil,
      nil
    )

    # board.valid_moves(color).each do |piece, moves|
    #   moves.each do |end_pos|
    #     start_pos = piece.pos
    #
    #     duped_board = board.deep_dup
    #     duped_piece = duped_board[start_pos]
    #
    #     duped_board.make_move(start_pos, end_pos, duped_piece)
    #     @tree.push({
    #       score: negamax(
    #         duped_board,
    #         0,
    #         SIGN[color],
    #         -Float::INFINITY,
    #         Float::INFINITY
    #       ),
    #       start_pos: start_pos,
    #       end_pos: end_pos
    #     })
    #   end
    # end
  end

  # def choose_best_move
  #   high_score = -Float::INFINITY
  #   best_move = nil
  #
  #   @tree.each do |move|
  #     if move[:score] > high_score
  #       high_score = move[:score]
  #       best_move = [move[:start_pos], move[:end_pos]]
  #     end
  #   end
  #
  #   @tree = []
  #   best_move
  # end

  def opponent_color
    @color == :white ? :black : :white
  end

  # def random_move
  #   moves = board.valid_moves(color)
  #
  #   piece = moves.keys.select { |k| !moves[k].empty? }.sample
  #   start_pos = piece.pos
  #   end_pos = moves[piece].sample
  #
  #   board.move(start_pos, end_pos)
  # end
end
