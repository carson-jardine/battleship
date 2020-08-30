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
    @hooman.hooman_place_ships
    test_array = @hooman.board.cells.values.select do |cell|
      cell if !cell.empty?
    end
    total_ship_cells = @hooman.ships.reduce(0) {|total, ship| total += ship.length}

    assert_equal total_ship_cells, test_array.length
  end

  def test_check_if_player_ships_have_sunk
    # skip
    assert_equal false, @cpu.ships_have_sunk?

    @cpu.cruiser.hit
    @cpu.cruiser.hit
    @cpu.cruiser.hit
    @cpu.submarine.hit
    @cpu.submarine.hit

    assert @cpu.ships_have_sunk?
  end

  def test_cpu_can_take_a_turn
    # skip

    @hooman.cpu_fires_zee_missle

    test_array = @hooman.board.cells.values.select do |cell|
      cell if cell.fired_upon?
    end
    bad_array = @hooman.board.cells.values.select do |cell|
      cell if !cell.fired_upon?
    end

    assert_equal 1, test_array[0].shots_fired
    assert_equal false, bad_array[0].fired_upon?
  end

  def test_hooman_can_take_a_turn
    # skip
    @cpu.hooman_fires_shot


    test_array = @cpu.board.cells.values.select do |cell|
      cell if cell.fired_upon?
    end
    bad_array = @cpu.board.cells.values.select do |cell|
      cell if !cell.fired_upon?
    end

    assert_equal 1, test_array[0].shots_fired
    assert_equal false, bad_array[4].fired_upon?
  end

  def test_hooman_duplicated_shot
    # skip

    cell_tested = @cpu.board.cells.fetch("B2")
    cell_tested.fire_upon
    puts "\nEnter B2 as your shot."
    @cpu.hooman_fires_shot

    test_array = @cpu.board.cells.values.select do |cell|
      cell if cell.fired_upon?
    end
    bad_array = @cpu.board.cells.values.select do |cell|
      cell if !cell.fired_upon?
    end

    assert_equal 2, cell_tested.shots_fired
    assert_equal 1, test_array[0].shots_fired
    assert_equal false, bad_array[4].fired_upon?

  end

end
