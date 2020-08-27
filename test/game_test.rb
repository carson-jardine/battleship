require 'minitest/autorun'
require 'minitest/pride'
require './lib/board'
require './lib/ship'
require './lib/cell'
require './lib/message'
require './lib/game'

class GameTest < Minitest::Test

  def setup
    @game = Game.new
    @board = Board.new
    @hooman = Player.new
    @cpu = Player.new
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_cpu_can_place_ships
    @game.cpu_place_ship(cpu_cruiser)
  end

end
