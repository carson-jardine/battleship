require 'minitest/autorun'
require 'minitest/pride'
require './lib/board'
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

    board2 = Board.new(125)
    assert_equal "BB-8", board2.cells["BB-8"].coordinate
    assert_equal "AB-3", board2.cells["AB-3"].coordinate
    assert_equal "A-1", board2.cells.first[0]
  end

  def test_has_valid_coordinates
    assert @board.valid_coordinate?("A-1")
    assert @board.valid_coordinate?("D-4")
    assert_equal false, @board.valid_coordinate?("A-5")
    assert_equal false, @board.valid_coordinate?("E-1")
    assert_equal false, @board.valid_coordinate?("A-22")

    board = Board.new(15)
    assert board.valid_coordinate?("A-15")
  end

  def test_valid_length_placement
    assert_equal false, @board.valid_placement?(@cruiser, ["A-1", "A-2"])
    assert_equal false, @board.valid_placement?(@submarine, ["A-2", "A-3", "A-4"])
    assert @board.valid_placement?(@cruiser, ["A-1", "A-2", "A-3"])
  end

  def test_valid_consecutive_placement
    assert_equal false, @board.valid_placement?(@cruiser, ["A-1", "A-2", "A-4"])
    assert_equal false, @board.valid_placement?(@submarine, ["A-1", "C-1"])
    assert_equal false, @board.valid_placement?(@cruiser, ["A-3", "A-2", "A-1"])
    assert_equal false, @board.valid_placement?(@submarine, ["C-1", "B-1"])
    assert @board.valid_placement?(@cruiser, ["A-1", "A-2", "A-3"])
    assert @board.valid_placement?(@submarine, ["B-2", "C-2"])
  end

  def test_valid_placement_if_diagonal
    assert_equal false, @board.valid_placement?(@cruiser, ["A-1", "B-2", "C-3"])
    assert_equal false, @board.valid_placement?(@submarine, ["C-2", "D-3"])
    assert @board.valid_placement?(@submarine, ["B-4", "C-4"])
  end

  def test_valid_vertical_and_horizontal_placement
    assert @board.valid_placement?(@submarine, ["A-1", "A-2"])
    assert @board.valid_placement?(@cruiser, ["B-1", "C-1", "D-1"])
  end

  def test_invalid_input
    assert_equal false, @board.valid_placement?(@submarine, ["Z-1", "Z-2"])
    assert_equal false, @board.valid_placement?(@cruiser, ["D-1", "E-1", "F-1"])
  end

  def test_it_can_place_a_ship_on_board
    @board.place(@cruiser, ["A-1", "A-2", "A-3"])
    cell_1 = @board.cells["A-1"]
    cell_2 = @board.cells["A-2"]
    cell_3 = @board.cells["A-3"]

    assert_equal @cruiser, cell_1.ship
    assert_equal @cruiser, cell_2.ship
    assert_equal @cruiser, cell_3.ship
    assert cell_3.ship == cell_2.ship
  end

  def test_overlapping_ships
    @board.place(@cruiser, ["A-1", "A-2", "A-3"])

    assert_equal false, @board.valid_placement?(@submarine, ["A-1", "B-1"])
    assert @board.valid_placement?(@submarine, ["B-1", "B-2"])
  end

  def test_it_can_render_board
    @board.place(@cruiser, ["A-1", "A-2", "A-3"])
    expected =  "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n"

    assert_equal expected, @board.render
  end

  def test_it_can_render_true
    @board.place(@cruiser, ["A-1", "A-2", "A-3"])
    @board.place(@submarine, ["B-2", "C-2"])
    expected = "  1 2 3 4 \nA S S S . \nB . S . . \nC . S . . \nD . . . . \n"

    assert_equal expected, @board.render(true)
  end

  def test_it_can_render_board_after_hit
    @board.place(@cruiser, ["A-1", "A-2", "A-3"])
    @board.cells["A-2"].fire_upon

    expected =  "  1 2 3 4 \nA . H . . \nB . . . . \nC . . . . \nD . . . . \n"
    expected_true =  "  1 2 3 4 \nA S H S . \nB . . . . \nC . . . . \nD . . . . \n"

    assert_equal expected, @board.render
    assert_equal expected_true, @board.render(true)
  end

  def test_it_can_render_board_after_miss
    @board.place(@cruiser, ["A-1", "A-2", "A-3"])
    @board.cells["D-2"].fire_upon

    expected =  "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . M . . \n"
    expected_true =  "  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . M . . \n"

    assert_equal expected, @board.render
    assert_equal expected_true, @board.render(true)
  end

  def test_it_can_render_after_ship_sunk
    @board.place(@cruiser, ["A-1", "A-2", "A-3"])
    @board.place(@submarine, ["B-2", "C-2"])

    @board.cells["A-1"].fire_upon
    @board.cells["A-2"].fire_upon
    @board.cells["A-3"].fire_upon


    expected =  "  1 2 3 4 \nA X X X . \nB . . . . \nC . . . . \nD . . . . \n"
    expected_true =  "  1 2 3 4 \nA X X X . \nB . S . . \nC . S . . \nD . . . . \n"

    assert_equal expected, @board.render
    assert_equal expected_true, @board.render(true)
  end

  def test_it_can_render_board_in_middle_of_game
    @board.place(@cruiser, ["A-1", "A-2", "A-3"])
    @board.place(@submarine, ["B-2", "C-2"])

    @board.cells["A-1"].fire_upon
    @board.cells["A-2"].fire_upon
    @board.cells["A-3"].fire_upon
    @board.cells["D-3"].fire_upon
    @board.cells["B-2"].fire_upon

    expected =  "  1 2 3 4 \nA X X X . \nB . H . . \nC . . . . \nD . . M . \n"
    expected_true =  "  1 2 3 4 \nA X X X . \nB . H . . \nC . S . . \nD . . M . \n"

    assert_equal expected, @board.render
    assert_equal expected_true, @board.render(true)
  end

  def test_place_different_ships_on_new_board
    game_ships = {'Bob' => 3}
    comp = Player.new(game_ships, 12)

    comp.hooman_cell_placement

    refute_nil comp.board.cells["A-1"].ship
    refute_nil comp.board.cells["A-2"].ship
    refute_nil comp.board.cells["A-3"].ship
    assert_nil comp.board.cells["B-1"].ship
  end

end
