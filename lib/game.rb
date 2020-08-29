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
      run_game
    elsif user_input == "q"
      exit
    else
      puts "Do you listen??? Let's try again"
      start
    end
  end

  def run_game
    @cpu.cpu_place_ships
    @hooman.hooman_place_ships
    while !@cpu.ships_have_sunk? && !@hooman.ships_have_sunk?
      turn
    end
    #run loop until either player has 2 sunk ships
  end

  def turn
    display_boards
    #@hooman.hooman_turn
    #@cpu.cpu_turn
    #results
  end

  def display_boards
    puts "\n \n"
    puts "=============COMPUTER BOARD============="
    print @cpu.board.render
    puts "\n"
    puts "==============HOOMAN BOARD=============="
    print @hooman.board.render(true)
  end

end
