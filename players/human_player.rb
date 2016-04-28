class HumanPlayer
  attr_reader :color, :display

  def initialize(display, color)
    @display = display
    @color = color
  end

  def make_a_move(&prc)
    @display.get_input
  end

  def to_s
    @color.to_s
  end

  def stats
  end
end
