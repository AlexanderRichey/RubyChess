class Display
  attr_reader :board
  include Cursorable

  def initialize(board)
    @board = board
    @cursor_pos = [0,0]
    @selected = false
  end

  def display_loop
    loop do
      system("clear")
      render
      get_input
    end
  end

  def render
    @board.board.each_with_index do |row, idx|
      puts row_display(row, idx)
    end
    puts "#{board.game.current_player}'s turn"
  end

  def row_display(row, row_idx)
    row_display = ""

    row.each_with_index do |piece, col_idx|
      if @cursor_pos == [row_idx, col_idx]
        row_display << " X "
      elsif piece.nil?
        row_display << " . "
      elsif @selected == [row_idx, col_idx]
        row_display << piece.symbol.colorize(:red)
      else
        row_display << piece.symbol.colorize(piece.display_color)
      end
    end

    row_display
  end

  def pick_up(pos)
    if @selected
      begin
        @board.move(@selected, pos)
      rescue BoardError => e
        puts e.message
        sleep(1)
      ensure
        @selected = false
      end
    else
      @selected = pos
    end
  end
end
