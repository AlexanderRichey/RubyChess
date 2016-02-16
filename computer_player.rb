class ComputerPlayer
  attr_reader :color, :board

  def initialize(display, color)
    @board = display.board
    @color = color
  end

  def make_a_move
    random_move
  end

  def to_s
    @color.to_s
  end

  private

  def random_move
    moves = Hash.new { Array.new }

    board.board.each do |row|
      row.each do |piece|
        next if piece.nil? || piece.color != color
        valid_moves = piece.valid_moves
        next if valid_moves.empty?

        moves[piece] = valid_moves.select { |move| ok_move?(piece.pos, move) }
      end
    end

    piece = moves.keys.select { |k| !moves[k].empty? }.sample
    start_pos = piece.pos
    end_pos = moves[piece].sample

    board.move(start_pos, end_pos)
  end

  def ok_move?(start_pos, end_pos)
    begin
      board.check_check(start_pos, end_pos, true)
    rescue BoardError
      return false
    end
    true
  end
end
