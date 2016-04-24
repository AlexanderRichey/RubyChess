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

  MAX_DEPTH = 2

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
      SIGN[color]
    )

    STATS[:end_time] = Time.now
    STATS[:diff] = STATS[:end_time] - STATS[:start_time]

    board.move(best_move[:start_pos], best_move[:end_pos])
    log_stats!

    prc.call
  end

  private
  def log_score!(score)
    File.open('log.txt', 'a') do |log|
      log.puts "Eval ##{STATS[:counter]} => #{score}"
    end
  end

  def log_board_score!(depth, score)
    File.open('log.txt', 'a') do |log|
      log.puts "Board Score => #{score}, Depth => #{depth}"
    end

    score
  end

  def sign_to_sym(sign)
    inverse_sign_map = {
      :"-1" => :white,
      :"1" => :black
    }

    inverse_sign_map[sign.to_s.to_sym]
  end

  def negamax(board_node, depth, sign)
    if depth > MAX_DEPTH
      return sign * board_node.score(sign_to_sym(sign))
    end

    max = -Float::INFINITY
    node = nil

    board_node.valid_moves(sign_to_sym(sign)).each do |piece, moves|
      moves.each do |end_pos|

        start_pos = piece.pos
        duped_board = board_node.deep_dup
        duped_piece = duped_board[start_pos]
        duped_board.make_move(start_pos, end_pos, duped_piece)

        evaluation = negamax(
          duped_board,
          depth + 1,
          sign * -1
        )

        STATS[:evaluations] += 1

        if evaluation.is_a?(Hash)
          score = evaluation[:score] * -1
        else
          score = evaluation * -1
        end

        log_board_score!(depth, score)

        if score > max
          max = score
          node = {
            score: max,
            start_pos: start_pos,
            end_pos: end_pos
          }
        end

      end
    end

    return node || max
  end

end
