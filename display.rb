class Display
  attr_reader :board
  include Cursorable

  def initialize(board)
    @board = board
    @cursor_pos = [0,0]
    @selected = false
  end

  def colors_for(i, j, color)
    if [i, j] == @cursor_pos
      bg = :light_red
    elsif (i + j).odd?
      bg = :default
    else
      bg = :light_white
    end
    { background: bg, color: color }
  end

  def render
    @board.board.each_with_index do |row, idx|
      puts row_display(row, idx)
    end
    puts "#{board.game.current_player.capitalize}'s turn"
    puts "#{board.game.current_player.capitalize} is in check" if @board.in_check?(board.game.current_player)
  end

  def row_display(row, row_idx)
    row_display = ""

    row.each_with_index do |piece, col_idx|
      if piece.nil?
        row_display << "   ".colorize(colors_for(row_idx, col_idx, :white))
      elsif @selected == [row_idx, col_idx]
        row_display << piece.symbol.colorize(colors_for(row_idx, col_idx, :red))
      else
        row_display << piece.symbol.colorize(colors_for(row_idx, col_idx, piece.display_color))
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
