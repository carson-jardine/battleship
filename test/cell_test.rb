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

  def test_it_has_attributes
    assert_equal "B4", @cell.coordinate
    assert_nil @cell.ship
  end

  def test_coordinate_starts_empty
    assert @cell.empty?
  end

  def test_it_can_place_a_ship
    cruiser = Ship.new("Cruiser", 3)
    @cell.place_ship(cruiser)

    assert_equal false, @cell.empty?
  end

  def test_fired_upon
    cruiser = Ship.new("Cruiser", 3)
    @cell.place_ship(cruiser)

    assert_equal false, @cell.fired_upon?
  end
# # => #<Ship:0x00007f84f0891238...>
#
# cell.place_ship(cruiser)
#
# cell.fired_upon?
# # => false
#
# cell.fire_upon
#
# cell.ship.health
# # => 2
#
# cell.fired_upon?
# # => true
end
