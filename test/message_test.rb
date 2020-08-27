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

  def test_hooman_cruiser_instructions
    expected = "Enter the squares for the Cruiser (3 spaces): \n> "

    assert_equal expected, @message.hooman_cruiser_instructions
  end

  def test_hooman_sub_instructions
    expected = "Enter the squares for the Submarine (2 spaces): \n> "

    assert_equal expected, @message.hooman_sub_instructions
  end

  def test_invalid_coordinate_user_input
    expected = "Those are invalid coordinates. Please try again: \n> "

    assert_equal expected, @message.invalid_coordinate_entry
  end

  def test_hooman_instructions_to_enter_shot_coordinates
    expected = "Enter the coordinate for your shot: \n> "

    assert_equal expected, @message.hooman_shot_coordinate_entry
  end

  def test_hooman_instructions_input_valid_shot_coordinates
    expected = "Please enter a valid coordinate: \n> "

    assert_equal expected, @message.hooman_valid_shot_entry
  end

  def test_message_to_hooman_shot
    cruiser = Ship.new("Cruiser", 3)
    cell_1 = Cell.new("A4")
    cell_1.fire_upon

    expected = "Your shot on A4 was a miss."
    assert_equal expected, @message.hooman_shot_results(cell_1)

    cell_1.place_ship(cruiser)
    cell_1.fire_upon
    expected = "Your shot on A4 was a hit."

    assert_equal expected, @message.hooman_shot_results(cell_1)

    cruiser.hit
    cruiser.hit
    expected = "Your shot on A4 was a hit, the ship is sunk."

    assert_equal expected, @message.hooman_shot_results(cell_1)
  end

end
