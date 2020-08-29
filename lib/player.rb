require './lib/ship'
require './lib/board'
require './lib/message'

class Player
  attr_reader :board, :cruiser, :submarine

  def initialize
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  def cpu_place_cruiser
    @cpu_cruiser = @board.cells.keys.shuffle[0..2]
    if @board.valid_placement?(@cruiser, @cpu_cruiser)
      @board.place(@cruiser, @cpu_cruiser)
    else
      cpu_place_cruiser
    end
  end

  def cpu_place_sub
    @cpu_sub = @board.cells.keys.shuffle[0..1]
    if @board.valid_placement?(@submarine, @cpu_sub)
      @board.place(@submarine, @cpu_sub)
    else
      cpu_place_sub
    end
  end

  def cpu_place_ships
    cpu_place_cruiser
    cpu_place_sub
  end

end
