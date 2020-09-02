require 'minitest/autorun'
require 'minitest/pride'
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


  def test_user_input_coords_successfully_converted
    user_input = "a1 a2 a3"
    assert_equal ["A-1", "A-2", "A-3"], @hooman.convert_input_coords(user_input)

    user_input2 = "aa1 ab1"
    assert_equal ["AA-1", "AB-1"], @hooman.convert_input_coords(user_input2)

    user_input3 = "ab22 ab23"
    assert_equal ["AB-22", "AB-23"], @hooman.convert_input_coords(user_input3)

    user_input4 = "a15"
    assert_equal ["A-15"], @hooman.convert_input_coords(user_input4)
  end

end
