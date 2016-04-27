class Display
  attr_reader :board, :game
  include Cursorable

  def initialize(game, board)
    @game = game
    @board = board
    @cursor_pos = [0,0]
    @selected = false
  end

  def render
    board.board.each_with_index do |row, idx|
      puts row_display(row, idx)
    end

    puts current_player
    puts computer_status

    if board.can_castle_left?(game.current_player.color)
      puts "Type 'l' to castle-left."
    end

    if board.can_castle_right?(game.current_player.color)
      puts "Type 'r' to castle-right."
    end

    if board.in_check?(game.current_player.color) && !board.checkmate?
      puts "#{game.current_player.to_s.capitalize} is in check."
    end
  end

  private
  def current_player
    if game.current_player.is_a?(ComputerPlayer)
      return "ComputerPlayer's turn..."
    else
      return "HumanPlayer's turn..."
    end
  end

  def computer_status
    if game.current_player.is_a?(ComputerPlayer)
      return "Analyzing move tree..."
    else
      return game.player_two.stats
    end
  end

  def colors_for(i, j, color)
    if [i, j] == @cursor_pos
      bg = :light_green
    elsif (i + j).odd?
      bg = :magenta
    else
      bg = :light_blue
    end
    { background: bg, color: color }
  end

  def pick_up(pos)
    if @selected
      begin
        board.move(@selected, pos)
        game.switch_players!
      rescue BoardError => e
        puts e.message
        sleep(1)
      ensure
        @selected = false
      end
    else
      if board[pos].nil?
        puts "There is no piece there."
      elsif board[pos].color == game.current_player.color
        @selected = pos
      else
        puts "That is not your piece."
      end
    end
  end

  def castle_right
    begin
      board.castle_right(game.current_player.color)
      game.switch_players!
    rescue BoardError => e
      puts e.message
      sleep(1)
    end
  end

  def castle_left
    begin
      board.castle_left(game.current_player.color)
      game.switch_players!
    rescue BoardError => e
      puts e.message
      sleep(1)
    end
  end

  def row_display(row, row_idx)
    row_display = ""

    row.each_with_index do |piece, col_idx|
      if piece.nil?
        row_display << "   ".colorize(colors_for(row_idx, col_idx, :white))
      elsif @selected == [row_idx, col_idx]
        row_display << piece.symbol.colorize(colors_for(row_idx, col_idx, :green))
      else
        row_display << piece.symbol.colorize(colors_for(row_idx, col_idx, piece.display_color))
      end
    end

    row_display
  end
end
