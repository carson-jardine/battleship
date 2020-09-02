require 'minitest/autorun'
require 'minitest/pride'
require './lib/cell'
require './lib/player'

class PlayerTest < Minitest::Test

  def setup
    @hooman = Player.new
    @cpu = Player.new
  end

  def test_it_exists
    assert_instance_of Player, @hooman
    assert_instance_of Player, @cpu
  end

  def test_cpu_can_place_ships
    @cpu.cpu_place_ships
    test_array = @cpu.board.cells.values.select do |cell|
      cell if !cell.empty?
    end
    total_ship_cells = @cpu.ships.reduce(0) {|total, ship| total += ship.length}
    assert_equal total_ship_cells, test_array.length
  end

  def test_hooman_can_place_ships

    @hooman.hooman_cell_placement
    refute_nil @hooman.board.cells["A-1"].ship
    refute_nil @hooman.board.cells["A-2"].ship
    refute_nil @hooman.board.cells["A-3"].ship
    assert_nil @hooman.board.cells["B-4"].ship
  end

  def test_check_if_player_ships_have_sunk

    assert_equal false, @cpu.ships_have_sunk?

    @cpu.ships[0].length.times do |i|
      @cpu.ships[0].hit
    end
    @cpu.ships[1].length.times do |i|
      @cpu.ships[1].hit
    end

    assert @cpu.ships_have_sunk?
  end

  def test_cpu_can_take_a_turn
    @hooman.cpu_fire_helper

    test_array = @hooman.board.cells.values.select do |cell|
      cell if cell.fired_upon?
    end
    bad_array = @hooman.board.cells.values.select do |cell|
      cell if !cell.fired_upon?
    end

    assert_equal 1, test_array[0].shots_fired
    assert_equal false, bad_array[0].fired_upon?
  end

  def test_cpu_can_take_adjacent_shot
    @hooman.board.cells["A-1"].place_ship(Ship.new("Cruiser", 3))
    @hooman.board.cells["A-1"].fire_upon
    @hooman.cpu_fire_helper

    test_array = @hooman.board.cells.values.select do |cell|
      cell if cell.fired_upon?
    end
    bad_array = @hooman.board.cells.values.select do |cell|
      cell if !cell.fired_upon?
    end

    assert_includes @hooman.generate_adjacent_cells(["A-1"]), test_array[1].coordinate
    assert_equal 1, test_array[0].shots_fired
    assert_equal false, bad_array[0].fired_upon?
  end

  def test_hooman_can_take_a_turn
    cell_1 = Cell.new("A-1")
    @cpu.hooman_take_shot(cell_1)

    assert cell_1.fired_upon?
  end

end
