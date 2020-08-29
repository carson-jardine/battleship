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

end
