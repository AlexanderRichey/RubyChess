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

b = Board.new
d = Display.new(b)
q = Queen.new(b, [1, 1])

d.display_loop
