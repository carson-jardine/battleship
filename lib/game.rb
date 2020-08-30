require './lib/player'

class Game
  attr_reader :hooman, :cpu

  def initialize
    @hooman = Player.new
    @cpu = Player.new
  end

  def start
    print "Welcome to BATTLESHIP \nEnter p to play. Enter q to quit. \n> "
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
      puts "You won!"
      initialize
      start
    elsif @hooman.ships_have_sunk?
      puts "I won! SUCK IT"
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
