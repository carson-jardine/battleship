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
    expected = "Welcome to BATTLESHIP \nEnter p to play. Enter q to quit. \n> "

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
    sub = Ship.new("Submarine", 2)
    cell_1 = Cell.new("A4")
    cell_2 = Cell.new("C4")
    cell_3 = Cell.new("D4")
    cell_1.fire_upon

    expected = "Your shot on A4 was a miss."
    assert_equal expected, @message.hooman_shot_results(cell_1)

    cell_2.place_ship(cruiser)
    cell_2.fire_upon
    expected = "Your shot on C4 was a hit."

    assert_equal expected, @message.hooman_shot_results(cell_2)

    cell_3.place_ship(sub)
    cell_3.fire_upon
    sub.hit
    expected = "Your shot on D4 was a hit, the ship is sunk."

    assert_equal expected, @message.hooman_shot_results(cell_3)
  end

  def test_repeated_shot_on_cell_message
    cell_1 = Cell.new("B4")
    cell_1.fire_upon
    cell_1.fire_upon

    expected = "Your shot on B4 was a failure. You already fired there. Try again."
    assert_equal expected, @message.hooman_shot_results(cell_1)
  end

  def test_game_end_messages
    assert_equal "You won!", @message.hooman_wins
    assert_equal "I won!", @message.cpu_wins
  end

end
