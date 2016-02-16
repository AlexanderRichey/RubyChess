require_relative 'relatives'

class Game
  attr_reader :current_player

  def initialize(board = nil)
    @board = board
    @current_player = :white
  end

  def run
    @board ||= Board.new(self)
    @display = Display.new(@board)
    play
  end

  def save_game
    puts "Enter a filename:"
    File.open(STDIN.gets.chomp, 'w') do |f|
      f.puts YAML.dump(@board)
    end
  end

  def switch_players!
    @current_player == :white ? @current_player = :black : @current_player = :white
  end

  def play
    until @board.checkmate?
      system("clear")
      @display.render
      @display.get_input
    end
    switch_players!
    puts "Checkmate! #{current_player.capitalize} wins!"
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
