require './lib/player'

class Game
  attr_reader :board_size, :ships

  def initialize(board_size = 4)
    @board_size = board_size
    @ships = {'Cruiser' => 3, 'Submarine' => 2}
    @hooman = nil
    @cpu = nil
  end

  def start
    print "Welcome to BATTLESHIP \nEnter p to play. Enter q to quit. \n> "
    user_input = gets.strip.chomp.downcase
    if user_input == "p"
      game_setup
    elsif user_input == "q"
      puts "Okay, quitter. BYEEEEE"
      exit
    else
      puts "Do you listen??? Let's try again"
      start
    end
  end

  def game_setup
    print "Sweet! Do you want to play with a custom board size and custom ships? Enter y or n \n> "
    user_input = gets.strip.chomp.downcase
    if user_input == 'y'
      custom_game
    elsif user_input == 'n'
      run_game
    else
      puts "You really don't listen huh?"
      game_setup
    end
  end

  def custom_game
    print "How big would you like to make your board? Please enter a number greater than 4 \n> "

    @board_size = gets.strip.chomp.to_i

    until @board_size >= 4
      print "Please enter a valid number, it's not that hard... \n\u{1f644} "
      @board_size = gets.strip.chomp.to_i
    end

    set_custom_ships
    run_game
  end

  def set_custom_ships
    puts "Hokay, now it's time to build some ships"
    @ships.clear
    print "How many ships would you like to have? \n> "
    ship_count = gets.strip.chomp.to_i

    until ship_count != 0
      print "Please enter a number, it's not that hard... \n\u{1f644} "
      ship_count= gets.strip.chomp.to_i
    end

    loop_counter = 1
    loop do
      print "What would you like ship number #{loop_counter.to_s} to be called? \n> "
      ship_name = gets.strip.chomp.capitalize

      print "How long do you want #{ship_name} to be? Please enter a number less than #{@board_size.to_s} \n> "
      ship_length = gets.strip.chomp.to_i

      until ship_length != 0
        print "Please enter a number, it's not that hard... \n\u{1f644} "
        ship_length = gets.chomp.to_i
      end

      until ship_length <= @board_size
        print "I told you LESS than #{@board_size.to_s}. Try again  \n\u{1f644} "
        ship_length = gets.strip.chomp.to_i
      end
      @ships[ship_name] = ship_length

      loop_counter += 1
      break if (loop_counter - 1) == ship_count
    end
  end

  def run_game
    @hooman = Player.new(@ships, @board_size)
    @cpu = Player.new(@ships, @board_size)
    @cpu.cpu_place_ships
    @hooman.hooman_place_ships
    while !@cpu.ships_have_sunk? && !@hooman.ships_have_sunk?
      turn
    end
    end_game
  end

  def turn
    display_boards
    @cpu.hooman_fires_shot
    @hooman.cpu_fires_zee_missle
  end

  def end_game
    if @cpu.ships_have_sunk? && @hooman.ships_have_sunk?
      puts "Let's call this a tie."
      initialize
      start
    elsif @cpu.ships_have_sunk?
      puts "Wowwww you beat a computer, you're sooooo smart \u{1f644}"
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
    system "clear"
    display_boards
    @cpu.hooman_fires_shot
    @hooman.cpu_fires_zee_missle
    sleep(1)
    # want to do this but show the log
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
