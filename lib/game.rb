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
    if @cpu.ships_have_sunk?
      @message.hooman_wins
      initialize
      start
    elsif @hooman.ships_have_sunk?
      @message.cpu_wins
      initialize
      start
    else
      puts "Oh no, what happened?"
    end
  end

  def turn
    display_boards
    @cpu.hooman_fires_shot
    @hooman.cpu_fires_zee_missle
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
