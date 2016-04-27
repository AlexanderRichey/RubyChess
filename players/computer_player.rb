class ComputerPlayer
  attr_reader :color, :board

  STATS = {
    start_time: nil,
    end_time: nil,
    diff: nil,
    counter: 0,
    turn: 0
  }

  SIGN = {
    white: -1,
    black: 1
  }

  MAX_DEPTH = 1 # Can only be odd numbers!

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

  def make_a_move(&prc)
    STATS[:turn] += 1
    STATS[:counter] = 0
    STATS[:start_time] = Time.now

    if STATS[:turn] == 1
      best_move = first_move
    else
      best_move = negamax(
        board,
        0,
        SIGN[color],
        -Float::INFINITY,
        Float::INFINITY,
        false
      )
    end

    STATS[:end_time] = Time.now
    STATS[:diff] = STATS[:end_time] - STATS[:start_time]

    board.move(best_move[:start_pos], best_move[:end_pos])

    prc.call
  end

  private
  def first_move
    if color == :white
      return { start_pos: [6, 4], end_pos: [4, 4] }
    else
      return { start_pos: [1, 2], end_pos: [3, 2] }
    end
  end

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

  def log_stats!(score) #for debugging
    File.open('log.txt', 'a') do |log|
      log.puts stats
      log.puts "The winning score was #{score}."
    end
  end

  def sign_to_sym(sign)
    inverse_sign_map = {
      :"-1" => :white,
      :"1" => :black
    }

    inverse_sign_map[sign.to_s.to_sym]
  end

  def negamax(board_node, depth, sign, alpha, beta, capture)
    if depth > MAX_DEPTH && !capture
      return sign * board_node.score(sign_to_sym(sign), alpha, beta)
    end

    node = nil

    board_node.valid_moves(sign_to_sym(sign)).each do |piece, moves|
      moves.each do |end_pos|
        start_piece = piece
        start_pos = piece.pos
        end_piece = board_node[end_pos]

        board_node.make_move!(start_pos, end_pos, start_piece)

        # Search one layer deeper if capture
        # if end_piece.is_a?(Piece) && capture == false
        #   capture = true
        # else
        #   capture = false
        # end

        evaluation = negamax(
          board_node,
          depth + 1,
          sign * -1,
          beta * -1,
          alpha * -1,
          capture
        )

        board_node.undo_move!(start_pos, end_pos, start_piece, end_piece)

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
