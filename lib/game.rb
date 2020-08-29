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
    if @cpu.ships_have_sunk
      @message.hooman_wins
      start
    elsif @hooman.ships_have_sunk
      @message.cpu_wins
      start
    else
      puts "Oh no, what happened?"
    end
  end

  def turn
    display_boards
    @hooman.hooman_fires_shot
    @cpu.cpu_fires_zee_missle
    # Note: The shot results messages are not in the right order. Not together I mean.
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
