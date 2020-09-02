require 'minitest/autorun'
require 'minitest/pride'
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

end
