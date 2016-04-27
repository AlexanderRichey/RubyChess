require_relative 'relatives'
require 'byebug'

class Game
  attr_reader :current_player, :player_one, :player_two

  def initialize(board = nil)
    @board = board || Board.new(self).populate_board!
    @display = Display.new(self, @board)

    @player_one = HumanPlayer.new(@display, :white)
    @player_two = ComputerPlayer.new(@display, :black)

    @current_player = player_one
  end

  def run
    play
  end

  def save_game
    puts "Enter a filename:"

    File.open(STDIN.gets.chomp, 'w') do |f|
      f.puts YAML.dump(@board)
    end
  end

  def switch_players!
    @current_player == player_one ? @current_player = player_two : @current_player = player_one
  end

  def play
    loop do
      system("clear")
      @display.render

      break if @board.game_over?
      current_player.make_a_move { self.switch_players! }
    end

    switch_players!
    puts "Checkmate! #{current_player.to_s.capitalize} Wins!"
  end
end

if __FILE__ == $PROGRAM_NAME
  if ARGV[0].nil?
    g = Game.new
    g.run
  else
    file = File.read(ARGV[0])
    board = YAML.load(file)
    g = Game.new(board)
    g.run
  end
end
