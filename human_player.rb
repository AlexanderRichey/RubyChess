class HumanPlayer
  attr_reader :color

  def initialize(display, color)
    @display = display
    @color = color
  end

  def make_a_move
    @display.get_input
  end

  def to_s
    @color.to_s
  end
end
