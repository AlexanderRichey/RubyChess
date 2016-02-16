require_relative 'relatives'

class Game
  attr_reader :white, :black, :current_player

  def initialize
    @white = :white
    @black = :black
    @current_player = :white
  end

  def switch_players!
    @current_player == white ? @current_player = black : @current_player = white
  end

  def run
    @board = Board.new(self)
    @board.populate_board
    @display = Display.new(@board)
    play
  end

  def play
    until @board.checkmate?
      system("clear")
      @display.render
      @display.get_input
    end
    puts "CHECKMATE"
  end
end

g = Game.new
g.run
