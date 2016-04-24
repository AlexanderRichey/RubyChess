require_relative 'node'

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

    evaluate_moves
    best_move = choose_best_move

    STATS[:end_time] = Time.now
    STATS[:diff] = STATS[:end_time] - STATS[:start_time]

    if best_move.nil?
      debugger
    end

    board.move(best_move[0], best_move[1])

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

  def negamax(node, depth, color)
    if depth == 0
      return SIGN[color] * node.score
    end

    best_value = -Float::INFINITY

    node.board.valid_moves(color).each do |piece, moves|
      moves.each do |end_pos|
        start_pos = piece.pos

        duped_board = node.board.deep_dup
        duped_piece = duped_board[start_pos]

        duped_board.make_move(start_pos, end_pos, duped_piece)
        value = -negamax(
          Node.new(duped_board, color, start_pos, end_pos),
          depth - 1,
          opponent_color
        )

        STATS[:evaluations] += 1

        if value > best_value
          best_value = value
        end

      end
    end

    return best_value
  end

  def evaluate_moves
    board.valid_moves(color).each do |piece, moves|
      moves.each do |end_pos|
        start_pos = piece.pos

        duped_board = board.deep_dup
        duped_piece = duped_board[start_pos]

        duped_board.make_move(start_pos, end_pos, duped_piece)
        @tree.push({
          score: negamax(
            Node.new(duped_board, color, start_pos, end_pos),
            2,
            color
          ),
          start_pos: start_pos,
          end_pos: end_pos
        })
      end
    end
  end

  def choose_best_move
    high_score = -Float::INFINITY
    best_move = nil

    @tree.each do |move|
      if move[:score] > high_score
        high_score = move[:score]
        best_move = [move[:start_pos], move[:end_pos]]
      end
    end

    @tree = []
    best_move
  end

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
