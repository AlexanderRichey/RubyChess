class ComputerPlayer
  attr_reader :color, :board

  STATS = {
    start_time: nil,
    end_time: nil,
    diff: nil,
    evaluations: 0
  }

  SIGN = {
    white: -1,
    black: 1
  }

  MAX_DEPTH = 3

  def initialize(display, color)
    @board = display.board
    @color = color
  end

  def to_s
    @color.to_s
  end

  def stats
    "Completed #{STATS[:evaluations]} evaluations in #{STATS[:diff]} seconds."
  end

  def log_stats!
    File.open('log.txt', 'a') do |log|
      log.puts stats
    end
  end

  def make_a_move(&prc)
    STATS[:evaluations] = 0
    STATS[:start_time] = Time.now

    best_move = negamax(
      board,
      0,
      SIGN[color],
      -Float::INFINITY,
      Float::INFINITY,
      nil,
      nil
    )

    STATS[:end_time] = Time.now
    STATS[:diff] = STATS[:end_time] - STATS[:start_time]

    board.move(best_move[:start_pos], best_move[:end_pos])
    log_stats!

    prc.call
  end

  private

  def sign_to_sym(sign)
    inverse_sign_map = {
      :"-1" => :white,
      :"1" => :black
    }

    inverse_sign_map[sign.to_s.to_sym]
  end


  def negamax(board_node, depth, sign, alpha, beta, init_start_pos, init_end_pos)
    if depth == MAX_DEPTH
      return {
        score: board_node.score(sign_to_sym(sign)),
        start_pos: init_start_pos,
        end_pos: init_end_pos
      }
    end

    alpha_start_pos, alpha_end_pos = nil, nil

    board_node.valid_moves(sign_to_sym(sign)).each do |piece, moves|
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
end
