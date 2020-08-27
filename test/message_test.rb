require 'minitest/autorun'
require 'minitest/pride'
require './lib/board'
require './lib/ship'
require './lib/cell'
require './lib/message'
require './lib/game'

class MessageTest < Minitest::Test

  def test_it_exists
    message = Message.new

    assert_instance_of Message, message
  end

end
