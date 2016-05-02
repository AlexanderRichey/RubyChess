class Evaluator
  def initialize(board, color)
    @board, @color = board, color

    @black_pieces = board.pieces_for(:black)
    @white_pieces = board.pieces_for(:white)

    @my_pieces = color == :white ? @white_pieces : @black_pieces
    @opponents_pieces = color == :white ? @black_pieces : @white_pieces
  end

  attr_reader :board, :color

  START_VALUE = 139

  def score
    material_value +
    pawn_development_value +
    minor_piece_development_value +
    major_piece_development_value
  end

  def end_game_score
    material_value +
    checkmate_value
  end

  private
  def material_value
    score = 0
    @my_pieces.each do |piece|
      score += piece.value
    end

    opp_score = 0
    @opponents_pieces.each do |piece|
      opp_score += piece.value
    end

    opp_diff = START_VALUE - opp_score

    score + opp_diff
  end

  def pawn_development_value
    color == :white ? white_pawn_value : black_pawn_value
  end

  def minor_piece_development_value
    color == :white ? white_minor_value : black_minor_value
  end

  def major_piece_development_value
    color == :white ? white_major_value : black_major_value
  end

  def black_pawn_value
    score = 0

    @black_pieces.select { |piece| piece.is_a?(Pawn) }.each do |pawn|
      score += (((pawn.pos[0] - 1).abs ** 2))
    end

    score.ceil
  end

  def white_pawn_value
    score = 0

    @white_pieces.select { |piece| piece.is_a?(Pawn) }.each do |pawn|
      score += (((pawn.pos[0] - 6).abs ** 2))
    end

    score.ceil
  end

  def black_minor_value
    score = 0

    black_minor_pieces.each do |minor_piece|
      score += (((minor_piece.pos[0]).abs ** 2))
    end

    score.ceil
  end

  def white_minor_value
    score = 0

    white_minor_pieces.each do |minor_piece|
      score += (((minor_piece.pos[0] - 7).abs ** 2))
    end

    score.ceil
  end

  def black_major_value
    score = 0

    black_major_pieces.each do |major_piece|
      score += (((major_piece.pos[0]).abs ** 2))
    end

    score.ceil
  end

  def white_major_value
    score = 0

    white_major_pieces.each do |major_piece|
      score += (((major_piece.pos[0] - 7).abs ** 2))
    end

    score.ceil
  end

  def checkmate_value
    if @opponents_pieces.none? { |piece| piece.is_a?(King) }
     return 100_000
    else
     return 0
    end
  end

  def minor_piece?(piece)
    piece.is_a?(Knight) || piece.is_a?(Bishop)
  end

  def major_piece?(piece)
    piece.is_a?(Rook) || piece.is_a?(Queen)
  end

  def white_minor_pieces
    @white_pieces.select { |piece| minor_piece?(piece) }
  end

  def white_major_pieces
    @white_pieces.select { |piece| major_piece?(piece) }
  end

  def black_minor_pieces
    @black_pieces.select { |piece| minor_piece?(piece) }
  end

  def black_major_pieces
    @black_pieces.select { |piece| major_piece?(piece) }
  end

  def valid_nonlegal_moves(color)
    color == :white ? white_nonlegal_moves : black_nonlegal_moves
  end

  def white_nonlegal_moves
    moves = Hash.new { Array.new }

    @white_pieces.each do |piece|
      moves[piece] = piece.valid_moves
    end

    moves
  end

  def black_nonlegal_moves
    moves = Hash.new { Array.new }

    @black_pieces.each do |piece|
      moves[piece] = piece.valid_moves
    end

    moves
  end

  def capture_moves(color)
    capture_moves = Hash.new { Array.new }

    valid_nonlegal_moves(color).each do |piece, moves|
      capture_moves[piece] = moves.select do |end_pos|
        board.capture?(piece.pos, end_pos)
      end
    end

    capture_moves
  end

  def opponent_color(color)
    color == :white ? :black : :white
  end
end
