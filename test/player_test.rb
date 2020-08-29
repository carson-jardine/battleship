require 'minitest/autorun'
require 'minitest/pride'
require './lib/board'
require './lib/ship'
require './lib/cell'
require './lib/message'
require './lib/game'
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

  def test_cpu_can_place_cruiser
    @cpu.cpu_place_cruiser
    test_array = @cpu.board.cells.values.select do |cell|
      cell if !cell.empty?
    end
    bad_array = @cpu.board.cells.values.select do |cell|
      cell if cell.empty?
    end
    assert_equal test_array[0].ship, @cpu.cruiser
    assert_equal test_array[1].ship, @cpu.cruiser
    assert_equal test_array[2].ship, @cpu.cruiser
    refute_equal bad_array[1].ship, @cpu.cruiser
  end

  def test_cpu_can_place_submarine
    @cpu.cpu_place_sub
    test_array = @cpu.board.cells.values.select do |cell|
      cell if !cell.empty?
    end
    bad_array = @cpu.board.cells.values.select do |cell|
      cell if cell.empty?
    end

    assert_equal test_array[0].ship, @cpu.submarine
    assert_equal test_array[1].ship, @cpu.submarine
    refute_equal bad_array[1].ship, @cpu.submarine
  end

  def test_hooman_can_place_cruiser
    skip
    @hooman.hooman_place_cruiser
    test_array = @hooman.board.cells.values.select do |cell|
      cell if !cell.empty?
    end
    bad_array = @hooman.board.cells.values.select do |cell|
      cell if cell.empty?
    end

    assert_equal test_array[0].ship, @hooman.cruiser
    assert_equal test_array[1].ship, @hooman.cruiser
    assert_equal test_array[2].ship, @hooman.cruiser
    refute_equal bad_array[1].ship, @hooman.cruiser

  end

  def test_hooman_can_place_submarine
    skip
    @hooman.hooman_place_sub
    test_array = @hooman.board.cells.values.select do |cell|
      cell if !cell.empty?
    end
    bad_array = @hooman.board.cells.values.select do |cell|
      cell if cell.empty?
    end

    assert_equal test_array[0].ship, @hooman.submarine
    assert_equal test_array[1].ship, @hooman.submarine
    refute_equal bad_array[1].ship, @hooman.submarine
  end

  def test_check_if_player_ships_have_sunk

    assert_equal false, @cpu.ships_have_sunk?

    @cpu.cruiser.hit
    @cpu.cruiser.hit
    @cpu.cruiser.hit
    @cpu.submarine.hit
    @cpu.submarine.hit

    assert @cpu.ships_have_sunk?
  end

  def test_hooman_can_take_a_turn
    @hooman.hooman_fires_shot

    test_array = @hooman.board.cells.values.select do |cell|
      cell if cell.fired_upon?
    end
    bad_array = @hooman.board.cells.values.select do |cell|
      cell if !cell.fired_upon?
    end

    assert_equal 1, test_array[0].shots_fired
    assert_equal false, bad_array[0].fired_upon?
  end

end
