require 'minitest/autorun'
require 'minitest/pride'
require './lib/board'
require './lib/ship'
require './lib/cell'
require './lib/player'

class BoardTest < Minitest::Test

  def setup
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  def test_it_exists
    assert_instance_of Board, @board
  end

  def test_has_cells
    assert_instance_of Hash, @board.cells
    assert_equal 16, @board.cells.keys.length
  end

  def test_board_can_be_larger
    board = Board.new(12)

    assert_equal 144, board.cells.keys.length
  end

  def test_has_valid_coordinates
    assert @board.valid_coordinate?("A1")
    assert @board.valid_coordinate?("D4")
    assert_equal false, @board.valid_coordinate?("A5")
    assert_equal false, @board.valid_coordinate?("E1")
    assert_equal false, @board.valid_coordinate?("A22")
  end

  def test_valid_length_placement
    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "A2"])
    assert_equal false, @board.valid_placement?(@submarine, ["A2", "A3", "A4"])
    assert @board.valid_placement?(@cruiser, ["A1", "A2", "A3"])
  end

  def test_valid_consecutive_placement
    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "A2", "A4"])
    assert_equal false, @board.valid_placement?(@submarine, ["A1", "C1"])
    assert_equal false, @board.valid_placement?(@cruiser, ["A3", "A2", "A1"])
    assert_equal false, @board.valid_placement?(@submarine, ["C1", "B1"])
    assert @board.valid_placement?(@cruiser, ["A1", "A2", "A3"])
    assert @board.valid_placement?(@submarine, ["B2", "C2"])
  end

  def test_valid_placement_if_diagonal
    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "B2", "C3"])
    assert_equal false, @board.valid_placement?(@submarine, ["C2", "D3"])
    assert @board.valid_placement?(@submarine, ["B4", "C4"])
  end

  def test_valid_vertical_and_horizontal_placement
    assert @board.valid_placement?(@submarine, ["A1", "A2"])
    assert @board.valid_placement?(@cruiser, ["B1", "C1", "D1"])
  end

  def test_invalid_input
  assert_equal false, @board.valid_placement?(@submarine, ["Z1", "Z2"])
  assert_equal false, @board.valid_placement?(@cruiser, ["D1", "E1", "F1"])
  end

  def test_it_can_place_a_ship_on_board
    @board.place(@cruiser, ["A1", "A2", "A3"])
    cell_1 = @board.cells["A1"]
    cell_2 = @board.cells["A2"]
    cell_3 = @board.cells["A3"]

    assert_equal @cruiser, cell_1.ship
    assert_equal @cruiser, cell_2.ship
    assert_equal @cruiser, cell_3.ship
    assert cell_3.ship == cell_2.ship
  end

  def test_overlapping_ships
    @board.place(@cruiser, ["A1", "A2", "A3"])

    assert_equal false, @board.valid_placement?(@submarine, ["A1", "B1"])
    assert @board.valid_placement?(@submarine, ["B1", "B2"])
  end

  def test_it_can_render_board
    @board.place(@cruiser, ["A1", "A2", "A3"])
    expected =  "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n"

    assert_equal expected, @board.render
  end

  def test_it_can_render_true
    @board.place(@cruiser, ["A1", "A2", "A3"])
    @board.place(@submarine, ["B2", "C2"])
    expected = "  1 2 3 4 \nA S S S . \nB . S . . \nC . S . . \nD . . . . \n"

    assert_equal expected, @board.render(true)
  end

  def test_it_can_render_board_after_hit
    @board.place(@cruiser, ["A1", "A2", "A3"])
    @board.cells["A2"].fire_upon

    expected =  "  1 2 3 4 \nA . H . . \nB . . . . \nC . . . . \nD . . . . \n"
    expected_true =  "  1 2 3 4 \nA S H S . \nB . . . . \nC . . . . \nD . . . . \n"

    assert_equal expected, @board.render
    assert_equal expected_true, @board.render(true)
  end

  def test_it_can_render_board_after_miss
    @board.place(@cruiser, ["A1", "A2", "A3"])
    @board.cells["D2"].fire_upon

    expected =  "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . M . . \n"
    expected_true =  "  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . M . . \n"

    assert_equal expected, @board.render
    assert_equal expected_true, @board.render(true)
  end

  def test_it_can_render_after_ship_sunk
    @board.place(@cruiser, ["A1", "A2", "A3"])
    @board.place(@submarine, ["B2", "C2"])

    @board.cells["A1"].fire_upon
    @board.cells["A2"].fire_upon
    @board.cells["A3"].fire_upon


    expected =  "  1 2 3 4 \nA X X X . \nB . . . . \nC . . . . \nD . . . . \n"
    expected_true =  "  1 2 3 4 \nA X X X . \nB . S . . \nC . S . . \nD . . . . \n"

    assert_equal expected, @board.render
    assert_equal expected_true, @board.render(true)
  end

  def test_it_can_render_board_in_middle_of_game
    @board.place(@cruiser, ["A1", "A2", "A3"])
    @board.place(@submarine, ["B2", "C2"])

    @board.cells["A1"].fire_upon
    @board.cells["A2"].fire_upon
    @board.cells["A3"].fire_upon
    @board.cells["D3"].fire_upon
    @board.cells["B2"].fire_upon

    expected =  "  1 2 3 4 \nA X X X . \nB . H . . \nC . . . . \nD . . M . \n"
    expected_true =  "  1 2 3 4 \nA X X X . \nB . H . . \nC . S . . \nD . . M . \n"

    assert_equal expected, @board.render
    assert_equal expected_true, @board.render(true)
  end

  def test_place_different_ships_on_new_board
    game_ships = {'Bob' => 3}
    comp = Player.new(game_ships, 12)

    comp.hooman_cell_placement

    refute_nil comp.board.cells["A1"].ship
    refute_nil comp.board.cells["A2"].ship
    refute_nil comp.board.cells["A3"].ship
    assert_nil comp.board.cells["B1"].ship
  end

end
