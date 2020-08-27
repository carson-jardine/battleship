require 'minitest/autorun'
require 'minitest/pride'
require './lib/board'
require './lib/ship'
require './lib/cell'
require './lib/message'
require './lib/game'

class MessageTest < Minitest::Test

  def setup
    @message = Message.new
  end

  def test_it_exists
    assert_instance_of Message, @message
  end

  def test_intro_for_game_display
    expected = "Welcome to BATTLESHIP \nEnter p to play. Enter q to quit."

    assert_equal expected, @message.main_menu
  end

  def test_hooman_instructions
    expected = "I have laid out my ships on the grid. \n
    You now need to lay out your two ships. \n
    The Cruiser is three units long and the Submarine is two units long."

    assert_equal expected, @message.hooman_instructions
  end

end
