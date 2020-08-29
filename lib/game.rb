require './lib/board'
require './lib/ship'
require './lib/cell'
require './lib/player'
require './lib/message'

class Game
  attr_reader :message, :hooman, :cpu

  def initialize
    @hooman = Player.new
    @cpu = Player.new
    @message = Message.new
  end

  def start
    @message.main_menu
    user_input = gets.chomp.downcase

    if user_input == "p"
      @cpu.cpu_place_ships
      #hooman.place_ships
    elsif user_input == "q"
      exit
    else
      puts "Do you listen???"
    end
  end

end
