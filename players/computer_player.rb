class ComputerPlayer
  attr_reader :color, :board, :max_depth

  STATS = {
    start_time: nil,
    end_time: nil,
    diff: nil,
    counter: 0,
    turn: 0
  }

  def initialize(display, color)
    @board = display.board
    @color = color
    @max_depth = 2
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
      best_move = choose_best_move
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

  def choose_best_move
    move_scores = Hash.new { |piece, moves| piece[moves] = [] }

    board.valid_moves(color).each do |piece, moves|
      moves.each do |end_pos|
        start_piece = piece
        start_pos = piece.pos
        end_piece = board[end_pos]

        board.make_move!(start_pos, end_pos, start_piece)

        score = negamax(
          board,
          0,
          flip_color(color),
          -Float::INFINITY,
          Float::INFINITY
        )

        board.undo_move!(start_pos, end_pos, start_piece, end_piece)

        move_scores[piece].push({ end_pos: end_pos, score: score })
      end
    end

    highest_scoring_move(move_scores)
  end

  def highest_scoring_move(move_score_hash)
    high_score = nil
    best_start_pos = nil
    best_end_pos = nil

    move_score_hash.each do |piece, moves|
      moves.each do |move_hash|
        if high_score.nil? || move_hash[:score] > high_score
          high_score = move_hash[:score]
          best_start_pos = piece.pos
          best_end_pos = move_hash[:end_pos]
        end
      end
    end

    { start_pos: best_start_pos, end_pos: best_end_pos }
  end

  def negamax(board_node, depth, cur_color, alpha, beta)
    if depth == max_depth
      return board_node.score(flip_color(cur_color))
    end

    board_node.valid_nonlegal_moves(cur_color).each do |piece, moves|
      moves.each do |end_pos|
        start_piece = piece
        start_pos = piece.pos
        end_piece = board_node[end_pos]

        board_node.make_move!(start_pos, end_pos, start_piece)

        score = -negamax(
          board_node,
          depth + 1,
          flip_color(cur_color),
          -beta,
          -alpha
        )

        board_node.undo_move!(start_pos, end_pos, start_piece, end_piece)

        STATS[:counter] += 1

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

  def flip_color(color)
    color == :white ? :black : :white
  end

end
