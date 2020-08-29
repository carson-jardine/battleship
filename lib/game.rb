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
    display_boards
  end

  def display_boards
    puts "=============COMPUTER BOARD============="
    print @cpu.board.render
    puts "==============HOOMAN BOARD=============="
    print @hooman.board.render(true)
  end

end
