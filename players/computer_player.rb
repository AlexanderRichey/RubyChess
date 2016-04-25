class ComputerPlayer
  attr_reader :color, :board

  STATS = {
    start_time: nil,
    end_time: nil,
    diff: nil,
    counter: 0
  }

  SIGN = {
    white: -1,
    black: 1
  }

  MAX_DEPTH = 1

  def initialize(display, color)
    @board = display.board
    @color = color
  end

  def to_s
    @color.to_s
  end

  def stats
    "Evaluated #{STATS[:counter]} tree nodes in #{STATS[:diff]} seconds."
  end

  def log_stats!(score)
    File.open('log.txt', 'a') do |log|
      log.puts stats
      log.puts "The winning score was #{score}."
    end
  end

  def make_a_move(&prc)
    STATS[:counter] = 0
    STATS[:start_time] = Time.now

    best_move = negamax(
      board,
      0,
      SIGN[color],
      -Float::INFINITY,
      Float::INFINITY
    )

    STATS[:end_time] = Time.now
    STATS[:diff] = STATS[:end_time] - STATS[:start_time]

    board.move(best_move[:start_pos], best_move[:end_pos])
    log_stats!(best_move[:score])

    prc.call
  end

  private
  def log_score!(score) #for debugging
    File.open('log.txt', 'a') do |log|
      log.puts "Eval ##{STATS[:counter]} => #{score}"
    end
  end

  def log_board_score!(score) #for debugging
    File.open('log.txt', 'a') do |log|
      log.puts "Board Score => #{score}"
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

  def negamax(board_node, depth, sign, alpha, beta)
    if depth > MAX_DEPTH
      return sign * board_node.score(sign_to_sym(sign), alpha, beta)
    end

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
          sign * -1,
          beta * -1,
          alpha * -1
        )

        STATS[:counter] += 1

        if evaluation.is_a?(Hash)
          score = evaluation[:score] * -1
        else
          score = evaluation * -1
        end

        if score >= beta
          return {
              score: beta,
              start_pos: start_pos,
              end_pos: end_pos
            }
        end

        if score > alpha
          alpha = score
          node = {
            score: alpha,
            start_pos: start_pos,
            end_pos: end_pos
          }
        end

      end
    end

    return node || alpha
  end

end
