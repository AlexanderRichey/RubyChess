class Node
  def initialize(board, color, start_pos, end_pos)
    @parent = nil
    @board = board
    @color = color
    @children = []
    @score = board.score(color)
    @start_pos = start_pos
    @end_pos = end_pos
  end

  attr_accessor :children, :parent
  attr_reader :board, :score, :start_pos, :end_pos, :color

  def add_child(child)
    children.push(child)
  end

  def remove_child(child)
    if child && !self.children.include?(child)
      raise "Tried to remove node that isn't a child"
    end

    child.remove_parent
  end

  def set_parent(parent)
    self.parent = parent
  end

  def remove_parent
    self.parent = nil
  end

  private

end
