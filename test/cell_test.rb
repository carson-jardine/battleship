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

    @cell.fire_upon

    assert_equal 2, @cell.ship.health
    assert @cell.fired_upon?
  end

  def test_it_can_render
    cell_1 = Cell.new("B4")

    assert_equal '.', cell_1.render

    cell_1.fire_upon

    assert_equal "M", cell_1.render

    cell_2 = Cell.new("C3")
    cruiser = Ship.new("Cruiser", 3)

    cell_2.place_ship(cruiser)

    assert_equal '.', cell_2.render
  end

  def test_it_can_render_optional_arg
    cell_2 = Cell.new("C3")
    cruiser = Ship.new("Cruiser", 3)

    cell_2.place_ship(cruiser)

    assert_equal "S", cell_2.render(true)

    cell_2.fire_upon
    assert_equal "H", cell_2.render
    assert_equal false, cruiser.sunk?
    cruiser.hit
    cruiser.hit

    assert cruiser.sunk?
    assert_equal "X", cell_2.render
  end

  def test_counting_shots_fired_on_cell
    cell_1 = Cell.new("D1")

    assert_equal 0, cell_1.shots_fired

    cell_1.fire_upon

    assert_equal 1, cell_1.shots_fired

    cell_1.fire_upon

    assert_equal 2, cell_1.shots_fired
  end

end
