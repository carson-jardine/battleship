require 'minitest/autorun'
require 'minitest/pride'
require './lib/board'
require './lib/cell'
require './lib/game'
require './lib/player'
require './lib/turn'

class TurnTest < Minitest::Test

  def setup
    @hooman = Player.new
    @cpu = Player.new
    @turn = Turn.new(@hooman, @cpu)
  end

  def test_it_exists
    assert_instance_of Turn, @turn
  end

  def test_cpu_can_take_a_turn
    @turn.cpu_fire_helper

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
    @turn.hooman.board.cells["A-1"].place_ship(Ship.new("Cruiser", 3))
    @turn.hooman.board.cells["A-1"].fire_upon
    @turn.cpu_fire_helper

    test_array = @hooman.board.cells.values.select do |cell|
      cell if cell.fired_upon?
    end
    bad_array = @hooman.board.cells.values.select do |cell|
      cell if !cell.fired_upon?
    end

    assert_includes @turn.generate_adjacent_cells(["A-1"]), test_array[1].coordinate
    assert_equal 1, test_array[0].shots_fired
    assert_equal false, bad_array[0].fired_upon?
  end

  def test_cpu_can_take_adjacent_shot_on_larger_board
    hooman = Player.new({'Submarine' => 2, 'Cruiser' =>3 }, 28)
    hooman.board.cells["AA-1"].place_ship(hooman.ships[1])
    hooman.board.cells["AA-1"].fire_upon
    @turn.cpu_fire_helper

    assert_equal ["AA-2", "AA-0", "Z-1", "AB-1"], @turn.generate_adjacent_cells(["AA-1"])
  end

  def test_cpu_can_take_adjacent_shot_using_z
    hooman = Player.new({'Submarine' => 2, 'Cruiser' =>3 }, 28)
    hooman.board.cells["Z-1"].place_ship(hooman.ships[1])
    hooman.board.cells["Z-1"].fire_upon
    @turn.cpu_fire_helper

    assert_equal ["Z-2", "Z-0", "Y-1", "AA-1"], @turn.generate_adjacent_cells(["Z-1"])
  end

  def test_hooman_can_take_a_turn
    cell_1 = Cell.new("A-1")
    @turn.hooman_take_shot(cell_1)

    assert cell_1.fired_upon?
  end



end
