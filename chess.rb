require 'io/console'
require_relative 'board'
require_relative 'piece'
require 'colorize'
require_relative 'cursorable'
require_relative 'display'
require_relative 'piece'
require_relative 'sliding_piece'
require_relative 'queen'
require_relative 'bishop'
require_relative 'rook'
require_relative 'stepping_piece'
require_relative 'knight'
require_relative 'king'
require_relative 'pawn'

class Game
  attr_reader :white, :black, :current_player

  def initialize(white, black)
    @white = :white
    @black = :black
    @current_player = :white
  end

  def switch_players!
    @current_player == white ? @current_player = black : @current_player = white
  end

  def play
    b = Board.new(self)
    b.populate_board
    d = Display.new(b)
    d.display_loop
  end
end

g = Game.new("Alex", "Dan")
g.play
