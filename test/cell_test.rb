require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'

class CellTest < Minitest::Test
  def setup
    @cell = Cell.new("B4")
  end

  def test_it_exists
    assert_instance_of Cell, @cell 
  end

  # cell.coordinate
  # # => "B4"
  #
  # cell.ship
  # # => nil
  #
  # cell.empty?
  # # => true
  #
  # cruiser = Ship.new("Cruiser", 3)
  # # => #<Ship:0x00007f84f0891238...>
  #
  # cell.place_ship(cruiser)
  #
  # cell.ship
  # # => #<Ship:0x00007f84f0891238...>
  #
  # cell.empty?
  # # => false
end
