require './lib/player'

class Game
  attr_reader :hooman, :cpu

  def initialize

  end

  def start
    print "Welcome to BATTLESHIP \nEnter p to play. Enter q to quit. \n> "
    user_input = gets.chomp.downcase
    if user_input == "p"
      set_board_size
    elsif user_input == "q"
      exit
    else
      puts "Do you listen??? Let's try again"
      start
    end
  end

  def set_board_size
    print "The standard board is 4 columns and 4 rows. \nWould you like to make the board bigger? (y/n) \n> "
    user_input = gets.chomp.downcase
    if user_input == "y"
      print "How big do you want to make it? Enter a number greater than 4. \nKeep in mind, the larger you make it, the longer the game will be. \n>"
      board_size = gets.chomp.to_i
      @hooman = Player.new(board_size)
      @cpu = Player.new(board_size)
      run_game
    elsif user_input == "n"
      @hooman = Player.new
      @cpu = Player.new
      run_game
    else
      puts "Do you listen??? Let's try again"
      set_board_size
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
