class Display
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
  end

  def row_display(row, row_idx)
    row_display = ""

    row.each_with_index do |space, col_idx|
      if @cursor_pos == [row_idx, col_idx]
        row_display << " X "
      elsif space.nil?
        row_display << " . "
      else
        row_display << " P "
      end
    end

    row_display
  end

  def pick_up(pos)
    if @selected
      @board.move(@selected, pos)
      @selected = false
    else
      @selected = pos
    end
  end
end
