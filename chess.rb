require 'io/console'
require_relative 'board'
require_relative 'piece'
require 'colorize'
require_relative 'cursorable'
require_relative 'display'

b = Board.new
d = Display.new(b)
d.display_loop
